import multer from 'multer';
import path from 'path';
import { v4 as uuid } from 'uuid';

// Path to store the cover image
var storageCover = multer.diskStorage({

    destination: 'uploads/profile/cover',
    filename: (_, file, cb) => {
        cb(null, uuid() + path.extname( file.originalname ));
    }
});

// Path to store the Profile image
var storageProfile = multer.diskStorage({

    destination: 'uploads/profile',
    filename: (req, file, cb): void => {
        cb(null, uuid() + path.extname( file.originalname ));
    }
});

// Path to store the posts images
var storagePost = multer.diskStorage({

    destination: 'uploads/posts',
    filename: (_, file, cb): void => {
        cb(null, uuid() + path.extname( file.originalname ));
    }
});

// Path to store the Story image
var storageStory = multer.diskStorage({

    destination: 'uploads/stories',
    filename: (_, file, cb): void => {
        cb(null, uuid() + path.extname( file.originalname ));
    }
});


export const uploadsCover = multer({storage : storageCover});
export const uploadsProfile = multer({storage: storageProfile});
export const uploadsPost = multer({storage: storagePost});
export const uploadsStory = multer({storage: storageStory});