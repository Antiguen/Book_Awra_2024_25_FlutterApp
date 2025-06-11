import { UserService } from './user.service';
export declare class UserController {
    private readonly userService;
    constructor(userService: UserService);
    getMe(req: any): Promise<import("../schemas/user.schema").User>;
    addToLibrary(req: any, bookId: string): Promise<{
        library: string[];
    }>;
    removeFromLibrary(req: any, bookId: string): Promise<{
        library: string[];
    }>;
    updateMe(req: any, body: any, image?: Express.Multer.File): Promise<import("../schemas/user.schema").User>;
}
