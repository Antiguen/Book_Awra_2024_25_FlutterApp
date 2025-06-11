import { Model } from "mongoose";
import { Profile } from "src/schemas/profile.schema";
import { CreateProfileDto } from "../dto/create-profile.dto";
import { SongsService } from "../song/songs.service";
import { UserService } from "src/user/user.service";
export declare class ProfileService {
    private readonly profileModel;
    private readonly songService;
    private readonly userService;
    constructor(profileModel: Model<Profile>, songService: SongsService, userService: UserService);
    create(data: CreateProfileDto & {
        email: string;
        imageData: Buffer;
        imageContentType: string;
    }): Promise<Profile>;
    findByArtist(artist: string): Promise<Profile>;
    updateProfileByEmail(email: string, data: CreateProfileDto & {
        imageData: Buffer;
        imageContentType: string;
    }): Promise<Profile>;
    findProfileWithSongs(artist: string): Promise<any>;
    createIfNotExists(data: {
        email: string;
        artist: string;
        bio?: string;
        genre?: string;
        description?: string;
        imageData?: Buffer;
        imageContentType?: string;
    }): Promise<void>;
}
