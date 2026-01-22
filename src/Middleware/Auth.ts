
import jwt, { type JwtPayload } from "jsonwebtoken"
import { HTTP_STATUS, type ApiErrorResponse } from "../types/api.js"
import * as dotenv from 'dotenv';
import type { Request, Response, NextFunction } from 'express';

dotenv.config()
const SECRET = process.env.JWT_SECRET || 'your_jwt_secret_key';

/* Extraction du token Bearer */
export const extractBearerToken = (headerValue: string) => {
    if (!headerValue || typeof headerValue !== 'string') return null;
    const parts = headerValue.split(' ');
    if (parts.length !== 2) return null;
    if (parts[0] !== 'Bearer') return null;
    return parts[1];
}
/* Vérification du token */
interface DecodedToken {
    [key: string]: any;
}

export const checkTokenMiddleware = (req: Request & { user?: JwtPayload }, res: Response, next: NextFunction) => {
    const token = req.headers.authorization && extractBearerToken(req.headers.authorization)
    // Présence d'un token
    if (!token) {
        const response_error_api: ApiErrorResponse = {
            success: false,
            status_code: HTTP_STATUS.FORBIDDEN,
            message: 'Error. Need a token',
            error: 'No token provided'
        }
        return res.status(response_error_api.status_code).json(response_error_api)
    }

    // Véracité du token
    jwt.verify(token, SECRET, (err ,decodedToken) => {
        if (err || !decodedToken) {
            const response_error_api: ApiErrorResponse = {
                success: false,
                status_code: HTTP_STATUS.BAD_REQUEST,
                message: 'Error. Bad token',
                error: err?.message || "Token invalid"
            };
            return res.status(response_error_api.status_code).json(response_error_api);
        } else {
            const payload = decodedToken as JwtPayload & DecodedToken;
             req.user = payload;
            console.log('decode token (payload)', decodedToken);
            return next()
        }
    });
}