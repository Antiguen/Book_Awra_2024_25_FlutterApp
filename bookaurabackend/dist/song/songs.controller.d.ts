import { Response } from 'express';
import { SongsService } from './songs.service';
import { CreateSongDto } from 'src/dto/create-songeDto';
export declare class SongsController {
    private readonly songsService;
    constructor(songsService: SongsService);
    uploadSong(createSongDto: CreateSongDto, files: {
        song?: Express.Multer.File[];
        image?: Express.Multer.File[];
    }): Promise<{
        success: boolean;
        message: string;
        data: {
            id: unknown;
            title: string;
            artist: string;
        };
    }>;
    getAllSongs(): Promise<any[]>;
    streamSong(id: string, res: Response): Promise<void>;
    getImage(id: string, res: Response): Promise<void>;
    getSongsByTitle(title: string): Promise<import("../schemas/song.schema").Song[]>;
    getSongsByArtist(artist: string): Promise<import("../schemas/song.schema").Song[]>;
    getSongById(id: string): Promise<{
        imageData: string;
        title: string;
        artist: string;
        album: string;
        genre: string;
        description: string;
        songData: Buffer;
        songContentType: string;
        imageContentType: string;
        uploadDate: Date;
        _id: unknown;
        $locals: Record<string, unknown>;
        $op: "save" | "validate" | "remove" | null;
        $where: Record<string, unknown>;
        baseModelName?: string;
        collection: import("mongoose").Collection;
        db: import("mongoose").Connection;
        errors?: import("mongoose").Error.ValidationError;
        id?: any;
        isNew: boolean;
        schema: import("mongoose").Schema;
        __v: number;
    }>;
    getSongPdf(id: string, res: Response): Promise<void>;
}
