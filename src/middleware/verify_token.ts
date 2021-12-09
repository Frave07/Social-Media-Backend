import { NextFunction, Request, Response } from "express";
import jwt from 'jsonwebtoken';


interface IPayload {
    idPerson: string;
}

// Verify token to Routes
export const verifyToken = (req: Request, res: Response, next: NextFunction) => {

    let token = req.header('xxx-token');

    if( !token ){
        return res.status(401).json({
            resp: false,
            message: 'Acceso denegado'
        });
    }

    try {

        const payload = jwt.verify( token, process.env.TOKEN_SECRET || 'Frave_Social' ) as IPayload;

        req.idPerson = payload.idPerson;

        next();

        
    } catch (err) {
        return res.status(500).json({
            resp: false,
            message: err
        });
    }
}

// Verify token to Socket 
export const verifyTokenSocket = ( token: string ): [boolean, string] => {

    try {

        const payload = jwt.verify( token, process.env.TOKEN_SECRET || 'Frave_Social' ) as IPayload;

        return [ true, payload.idPerson ];
        
    } catch (err) {
        return [ false, '' ];
    }

}