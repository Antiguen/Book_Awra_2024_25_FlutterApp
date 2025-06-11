import { Document } from 'mongoose';
export declare class Song extends Document {
    title: string;
    artist: string;
    album: string;
    genre: string;
    description: string;
    songData: Buffer;
    songContentType: string;
    imageData: Buffer;
    imageContentType: string;
    uploadDate: Date;
}
export declare const SongSchema: import("mongoose").Schema<Song, import("mongoose").Model<Song, any, any, any, Document<unknown, any, Song, any> & Song & Required<{
    _id: unknown;
}> & {
    __v: number;
}, any>, {}, {}, {}, {}, import("mongoose").DefaultSchemaOptions, Song, Document<unknown, {}, import("mongoose").FlatRecord<Song>, {}> & import("mongoose").FlatRecord<Song> & Required<{
    _id: unknown;
}> & {
    __v: number;
}>;
