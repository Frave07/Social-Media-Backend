import { Router } from 'express';
import { verifyToken } from '../middleware/verify_token';
import * as story from '../controllers/story_controller';
import { uploadsPost, uploadsStory } from '../lib/multer';


const router = Router();

    
    router.post('/story/create-new-story', [ verifyToken, uploadsStory.single('imageStory') ], story.addNewStory );
    router.get('/story/get-all-stories-home', [ verifyToken ], story.getAllStoryHome );
    router.get('/story/get-story-by-user/:idStory', [ verifyToken], story.getStoryByUser );

export default router;