import express, { Router, Request, Response } from 'express';
import studentRoutes from './studentsRoutes';

const router: Router = express.Router();

router.use('/students', studentRoutes);


router.get('/about', (req: Request, res: Response) => {
  res.send('This is the about page.');
});

export default router;