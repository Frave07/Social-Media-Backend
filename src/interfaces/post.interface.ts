
export interface INewPost {
    comment: string,
    user_uid: string,
    type_privacy: string
}

export interface ISavePost {
    post_uid: string
}

export interface ILikePost {
    uidPost: string,
    uidPerson: string
}

export interface INewComment {
    uidPost: string,
    comment: string
}

export interface IUidComment {
    uidComment: string
}