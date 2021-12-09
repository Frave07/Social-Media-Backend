import express, { Application } from 'express';
import cors from 'cors';
import path from 'path';
import { createServer, Server } from 'http';
import ServerSocket from 'socket.io';
import routesUser from './routes/user.routes';
import routesAuth from './routes/auth.routes';
import routesPost from './routes/post.routes';
import routesNotifications from './routes/notifications.routes';
import routesStory from './routes/story.routes';
import routesChat from './routes/chat.routes';
import { socketChatMessages } from './sockets/chat_socket';


export class App {

    private app: Application;
    private httpServer: Server;

    private apiRoutes = {
        user: '/api',
        auth: '/api',
        post: '/api',
        notification: '/api',
        story: '/api',
        chat: '/api',
    }

    constructor(){
        this.app = express();

        this.httpServer = createServer(this.app);

        this.middlewares();
        this.routes();
        this.configServerSocket();
    }

    private middlewares(){
        this.app.use( cors() );
        this.app.use( express.json() );
        this.app.use( express.urlencoded({ extended: false }) );

        this.app.use( express.static( path.resolve('uploads/profile')));
        this.app.use( express.static( path.resolve('uploads/profile/cover')));
        this.app.use( express.static( path.resolve('uploads/posts')));
        this.app.use( express.static( path.resolve('uploads/stories')));
    }

    private routes(){
        this.app.use( this.apiRoutes.user, routesUser );
        this.app.use( this.apiRoutes.auth, routesAuth );
        this.app.use( this.apiRoutes.post, routesPost );
        this.app.use( this.apiRoutes.notification, routesNotifications );
        this.app.use( this.apiRoutes.story, routesStory );
        this.app.use( this.apiRoutes.chat, routesChat );
    }

    private configServerSocket(){

        const io = new ServerSocket(this.httpServer);
        socketChatMessages(io);

    }

    async listen(port: string): Promise<void> {

        await this.httpServer.listen( port );
        console.log(`SERVER RUN ON PORT ${ port }`)
    }

}