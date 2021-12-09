import { Router } from 'express';
import { verifyToken } from '../middleware/verify_token';
import * as post from '../controllers/post_controller';
import { uploadsPost } from '../lib/multer';


const router = Router();

    router.post('/post/create-new-post', [ verifyToken, uploadsPost.array('imagePosts') ], post.createNewPost);
    router.get('/post/get-all-posts', verifyToken, post.getAllPostHome); 
    router.get('/post/get-post-by-idPerson', verifyToken, post.getPostByIdPerson); 
    router.post('/post/save-post-by-user', verifyToken, post.savePostByUser); 
    router.get('/post/get-list-saved-posts', verifyToken, post.getListSavedPostsByUser); 
    router.get('/post/get-all-posts-for-search', verifyToken, post.getAllPostsForSearch);
    router.post('/post/like-or-unlike-post', verifyToken, post.likeOrUnLikePost);
    router.get('/post/get-comments-by-idpost/:uidPost', verifyToken, post.getCommentsByIdPost );
    router.post('/post/add-new-comment', verifyToken, post.addNewComment);
    router.put('/post/like-or-unlike-comment', verifyToken, post.likeOrUnLikeComment);
    router.get('/post/get-all-post-by-user-id', verifyToken, post.getAllPostByUserID );


export default router;
