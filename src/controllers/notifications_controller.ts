import { Request, Response } from 'express';
import { connect } from '../database/connection';
import { RowDataPacket } from 'mysql2';


export const getNotificationsByUser = async (req: Request, res: Response): Promise<Response> => {

    try {

        const conn = await connect();

        const notificationdb = await conn.query<RowDataPacket[]>(`CALL SP_GET_NOTIFICATION_BY_USER(?)`, [ req.idPerson ]);

        conn.end();

        return res.json({
            resp: true,
            message: 'Get Notifications',
            notificationsdb: notificationdb[0][0]
        });

    } catch(err) {
        return res.status(500).json({
            resp: false,
            message: err
        });
    }

}