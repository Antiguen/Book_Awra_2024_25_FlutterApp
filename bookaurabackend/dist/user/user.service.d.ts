import { Model } from 'mongoose';
import { User } from '../schemas/user.schema';
export declare class UserService {
    private readonly userModel;
    constructor(userModel: Model<User>);
    findByEmail(email: string): Promise<User | null>;
}
