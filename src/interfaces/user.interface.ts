
export interface User {

    username: string;
    fullname: string;
    email: string;
    password: string;
}

export interface IUpdateProfile {
    user?: string;
    description?: string;
    fullname?: string;
    phone?: string;
}

export interface IChangePassword {
    currentPassword: string;
    newPassword: string
}

export interface INewFriend {
    uidFriend: string
}

export interface IAcceptFollowerRequest {
    uidFriend: string,
    uidNotification: string
}