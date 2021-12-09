import { Server } from 'socket.io';
import { addNewMessage, InsertListChat, updateLastMessage } from '../controllers/chat_controller';
import { updateOfflineUser, updateOnlineUser } from '../controllers/user_controller';
import { verifyTokenSocket } from '../middleware/verify_token';


export const socketChatMessages = ( io: Server ) => {


    const nameSpaceChat = io.of('/socket-chat-message');


    nameSpaceChat.on('connection', async client => {

        const [ verify, uidPerson ] = verifyTokenSocket( client.handshake.headers['xxx-token'] );

        if( !verify ) { return client.disconnect(); }

        console.log('USER CONECTED');

        await updateOnlineUser( uidPerson );


        client.join( uidPerson );

        client.on('message-personal', async payload => {

            console.log(payload);

            await InsertListChat(payload.from, payload.to);

            await updateLastMessage(payload.to, payload.from, payload.message);

            await addNewMessage(payload.from, payload.to, payload.message);
            
            nameSpaceChat.to( payload.to ).emit('message-personal', payload );
        });



        client.on('disconnect', async _ => {

            await updateOfflineUser( uidPerson );
            console.log('USER DISCONNECT');

        });

    });

}