import express from 'express';
import type { Request, Response } from 'express';
import cors from 'cors';
import morgan, { token } from 'morgan';
import jwt, { type JwtPayload } from 'jsonwebtoken';
import { HTTP_STATUS, isKeyExists, type ApiErrorResponse, type ApiErrorValidationResponse, type ApiResponseOk, type AuthLogin, type User } from './types/api.js';
import pool, { TableSql } from './Config/db.config.js';
import * as dotenv from 'dotenv';
import bcrypt from 'bcrypt';
import { checkTokenMiddleware, extractBearerToken } from './Middleware/Auth.js';
const SECRET = process.env.JWT_SECRET || 'your_jwt_secret_key';


const app = express();
const PORT = process.env.PORT || 3003;

// Middleware
app.use(cors({ 
  origin: [(process.env.FRONTEND_ORIGIN && process.env.FRONTEND_ORIGIN.startsWith('http') ? process.env.FRONTEND_ORIGIN : `http://${process.env.FRONTEND_ORIGIN || 'localhost:3001'}`), 'http://sigif-cm.com'], 
  credentials: true })
);
app.use(morgan('tiny'));
app.use(express.json());
app.use(express.urlencoded({ extended: true }))

app.use((req: Request, _res: Response, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.url} ${req.body ?? 'No body content'}`);
  next();
});

const users = [
    { id: 1, username: 'admin', password: 'password123', email: 'admin@example.com' , nom: 'Admin', prenom: 'User', role: 'administrator'},
    { id: 2, username: 'johndoe', password: 'mypassword', email: 'johndoe@example.com', nom: 'John', prenom: 'Doe', role: 'user'},
]


// Routes 
// test pour login
app.post('/login', (req: Request, res: Response) => {
  const required = ['username', 'password'];
  const user_login: AuthLogin = req.body;
  const missing = required.filter((k) => !(user_login as any)[k]);

    if (missing.length > 0) {
      const response_validation_errors: ApiErrorValidationResponse = {
        success: false,
        status_code: HTTP_STATUS.NOT_FOUND,
        message: `Champs requis manquants: ${missing.join(', ')}`,
        errors: missing.reduce((acc, field) => {
          acc[field] = `Le champ ${field} est requis.`;
          return acc;
        }, {} as Record<string, string>)
      };
      console.log(response_validation_errors);
      return res.status(response_validation_errors.status_code).json(response_validation_errors);
    }
    // fetching
    const user: Partial<User> = users.find(u => u.username === user_login.username && u.password === user_login.password) as User;
    if (!user) {
      const response_error_api: ApiErrorResponse = {
        success: false,
        status_code: HTTP_STATUS.UNPROCESSABLE_ENTITY,
        message: 'Nom d\'utilisateur ou mot de passe incorrect.'
      };
      console.log(response_error_api);
      return res.status(response_error_api.status_code).json(response_error_api);
    }
    
    const token = jwt.sign({
      id: user.id,
      username: user.username
    }, SECRET, { expiresIn: '3 hours' })

    const response_api: ApiResponseOk<Partial<User & { token: string }>> = {
        success: true,
        status_code: HTTP_STATUS.OK,
        message: 'Authentification réussie.',
        data: { ...user, token  }
      };
      console.log('response authentification:', response_api);
    return res.status(response_api.status_code).json(response_api);

})

// login réel
app.post('/api/auth', async (req: Request, res: Response) => {

  const { email, password } = req.body;

  if (!email || !password) {
    const missing = [];
    if (!email) missing.push('email');
    if (!password) missing.push('password');
    const response_validation_errors: ApiErrorValidationResponse = {
      success: false,
      status_code: HTTP_STATUS.BAD_REQUEST,
      message: `Champs requis manquants: ${missing.join(', ')}`,
      errors: missing.reduce((acc, field) => {
        acc[field] = `Le champ ${field} est requis.`;
        return acc;
      }, {} as Record<string, string>)
    };
    res.status(response_validation_errors.status_code).json(response_validation_errors);
  }
  try {
      const [rows] = await pool.execute(
          `SELECT id, email, password_hash FROM ${TableSql.Users} WHERE email = ?`, [email]
      )

      const users = rows as any[];
      console.log('users récupéré en bd', users);
      

      if (users.length === 0) {
        const response_error_api : ApiErrorResponse = {
          success: false,
          status_code: HTTP_STATUS.UNAUTHORIZED,
          message: "Utilisateur inconnu.",
          error: "No user found with the provided email."
        };
        console.log('Utilisateur inconnu:', response_error_api);
        return res.status(response_error_api.status_code).json(response_error_api);
      }
      // vérification du mot de passe
      const user = users[0]
      const match = await bcrypt.compare(password, user.password_hash);

      if (!match) {
        const response_error_api : ApiErrorResponse = {
          success: false,
          status_code: HTTP_STATUS.UNAUTHORIZED,
          message: 'login incorrect.',
          error: "Mot de passe incorrect."
        };
        console.log('Mauvais mot de passe:', response_error_api);
        return res.status(response_error_api.status_code).json(response_error_api);
      }

      // sinon on génère un JWT token
      const token = jwt.sign(
          { id: user.id, email: user.email },
          process.env.JWT_SECRET || "secretKey",
          { expiresIn: "24h" }
      );
      const response_api: ApiResponseOk<Partial<User & { token: string }>> = {
        success: true,
        status_code: HTTP_STATUS.OK,
        message: 'Authentification réussie.',
        data: { ...user, token  }
      };
      console.log('response authentification:', response_api);
      return res.status(response_api.status_code).json(response_api);
  } catch (err) {
    const error = err as Error;
    const response_api_error: ApiErrorResponse = {
      success: false,
      status_code:  HTTP_STATUS.INTERNAL_SERVER_ERROR,
      message: 'Erreur lors de l\'authentification.',
      error: process.env.NODE_ENV === 'development' ? error.message : 'Un problème est survenu lors de l\'authentification'
    };
    console.error('Auth login:', response_api_error);
    res.status(response_api_error.status_code).json(response_api_error);
  }

})

app.get('/me', checkTokenMiddleware, (req: Request & { user?: JwtPayload }, res: Response) => {
  const response_api : ApiResponseOk<JwtPayload> = {
    success: true,
    status_code: HTTP_STATUS.OK,
    message: 'Token valide.',
    data: req.user as JwtPayload
  };
  console.log('response /me:', response_api);
  return res.status(response_api.status_code).json(response_api);
})

app.get('/', (req: Request, res: Response) => {
  res.send('Hello, TypeScript and Express for my auth management api!');
});
  
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});