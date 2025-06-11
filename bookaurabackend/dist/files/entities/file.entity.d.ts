import { Document } from 'mongoose';
export declare class File extends Document {
    filename: string;
    contentType: string;
    length: number;
    uploadDate: Date;
}
export declare const FileSchema: import("mongoose").Schema<File, import("mongoose").Model<File, any, any, any, Document<unknown, any, File, any> & File & Required<{
    _id: unknown;
}> & {
    __v: number;
}, any>, {}, {}, {}, {}, import("mongoose").DefaultSchemaOptions, File, Document<unknown, {}, import("mongoose").FlatRecord<File>, {}> & import("mongoose").FlatRecord<File> & Required<{
    _id: unknown;
}> & {
    __v: number;
}>;
