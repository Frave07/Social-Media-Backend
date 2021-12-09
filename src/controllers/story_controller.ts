import { Request, Response } from 'express';
import { v4 as uuidv4 } from 'uuid';
import { connect } from '../database/connection';
import { RowDataPacket } from 'mysql2';


export const addNewStory = async (req: Request, res: Response): Promise<Response> => {

    try {

        const conn = await connect();

        const userdb = await conn.query<RowDataPacket[]>('SELECT uid_story FROM stories WHERE user_uid = ? LIMIT 1', req.idPerson );

        if( userdb[0].length > 0 ){

            await conn.query('INSERT INTO media_story (uid_media_story, media, story_uid) VALUE (?,?,?)', [ uuidv4(), req.file?.filename, userdb[0][0].uid_story ]);

            return res.json({
                resp: true,
                message: 'new story'
            }); 

        }

        await conn.query(`CALL SP_ADD_NEW_STORY(?,?,?,?);`, [ uuidv4(), req.idPerson, uuidv4(), req.file?.filename ]);

        return res.json({
            resp: true,
            message: 'new story',
            userdb: userdb[0],
            count: userdb[0].length
        });

    } catch(err) {
        return res.status(500).json({
            resp: false,
            message: err
        });
    }
}

export const getAllStoryHome = async (req: Request, res: Response): Promise<Response> => {

    try {

        const conn = await connect();

        const storiesdb = await conn.query<RowDataPacket[]>(`CALL SP_GET_ALL_STORIES_HOME(?);`, [req.idPerson]);

        conn.end();

        return res.json({
            resp: true,
            message: 'Get All Stories By User',
            stories: storiesdb[0][0]
        });

    } catch(err) {
        return res.status(500).json({
            resp: false,
            message: err
        });
    }

}

export const getStoryByUser = async (req: Request, res: Response): Promise<Response> => {

    try {

        const conn = await connect();

        const storydb = await conn.query<RowDataPacket[]>(`CALL SP_GET_STORY_BY_USER(?);`, [ req.params.idStory ]);

        conn.end();

        return res.json({
            resp: true,
            message: 'Get Stories',
            listStories: storydb[0][0]
        });

    } catch(err) {
        return res.status(500).json({
            resp: false,
            message: err
        });
    }

}