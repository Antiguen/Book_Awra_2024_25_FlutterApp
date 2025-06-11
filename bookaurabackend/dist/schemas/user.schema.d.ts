import { Document } from "mongoose";
import { UserRole } from "./user-role.enum";
export declare class User extends Document {
    userId: string;
    fullName: string;
    email: string;
    userPassword: string;
    dateOfBirth: string;
    gender: string;
    role: UserRole;
    status: boolean;
    verificationCode: string;
    library: string[];
    bio: string;
    genre: string;
    description: string;
    imageData: Buffer;
    imageContentType: string;
}
export declare const UserSchema: import("mongoose").Schema<User, import("mongoose").Model<User, any, any, any, Document<unknown, any, User, any> & User & Required<{
    _id: unknown;
}> & {
    __v: number;
}, any>, {}, {}, {}, {}, import("mongoose").DefaultSchemaOptions, User, Document<unknown, {}, import("mongoose").FlatRecord<User>, {}> & import("mongoose").FlatRecord<User> & Required<{
    _id: unknown;
}> & {
    __v: number;
}>;
