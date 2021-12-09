import { Router } from 'express';
import * as user from '../controllers/user_controller';
import { uploadsCover, uploadsProfile } from '../lib/multer';
import { verifyToken } from '../middleware/verify_token';

const router = Router();

    router.post('/user', user.createUser );
    router.get('/user/get-User-By-Id', verifyToken, user.getUserById );
    router.get('/user/verify-email/:code/:email', user.verifyEmail );
    // Middleware [ Token, image ]  - Profile Image required
    router.put('/user/update-cover', [ verifyToken, uploadsCover.single('cover') ], user.updatePictureCover );
    router.put('/user/update-image-profile', [ verifyToken, uploadsProfile.single('profile') ], user.updatePictureProfile );
    router.put('/user/update-data-profile', verifyToken, user.updateProfile );
    router.put('/user/change-password', verifyToken, user.changePassword );
    router.put('/user/change-account-privacy', verifyToken, user.changeAccountPrivacy );

    router.get('/user/get-search-user/:username', verifyToken, user.getSearchUser );
    router.get('/user/get-another-user-by-id/:idUser', verifyToken, user.getAnotherUserById );
    router.post('/user/add-new-friend', verifyToken, user.AddNewFollowing );
    router.post('/user/accept-follower-request', verifyToken, user.AcceptFollowerRequest );
    router.delete('/user/delete-following/:idUser', verifyToken, user.deleteFollowing);
    router.get('/user/get-all-following', verifyToken, user.getAllFollowings );
    router.get('/user/get-all-followers', verifyToken, user.getAllFollowers );
    router.delete('/user/delete-followers/:idUser', verifyToken, user.deleteFollowers);
    


export default router;