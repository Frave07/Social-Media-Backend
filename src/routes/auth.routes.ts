import { Router } from 'express';
import * as auth from '../controllers/auth_controller';
import { verifyToken } from '../middleware/verify_token';

const router = Router();


    router.post('/auth-login', auth.login);
    router.get('/auth/renew-login', verifyToken ,auth.renweLogin);


export default router;