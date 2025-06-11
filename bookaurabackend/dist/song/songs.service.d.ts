import { Model } from "mongoose";
import { Song } from "src/schemas/song.schema";
import { CreateSongDto } from "src/dto/create-songeDto";
export declare class SongsService {
    private readonly songModel;
    constructor(songModel: Model<Song>);
    create(data: CreateSongDto & {
        songData: Buffer;
        songContentType: string;
        imageData: Buffer;
        imageContentType: string;
    }): Promise<Song>;
    findAll(): Promise<any[]>;
    findById(id: string): Promise<{
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
    findByTitle(title: string): Promise<Song[]>;
    findByArtist(artist: string): Promise<Song[]>;
    getSongData(id: string): Promise<{
        data: Buffer;
        contentType: string;
    }>;
    getImageData(id: string): Promise<{
        data: Buffer;
        contentType: string;
    }>;
}
