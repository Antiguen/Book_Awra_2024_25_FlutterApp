import { Connection } from 'mongoose';
export declare class FilesService {
    private connection;
    private bucket;
    constructor(connection: Connection);
    uploadFile(file: Express.Multer.File): Promise<unknown>;
    getFiles(): Promise<import("mongodb").GridFSFile[]>;
    downloadFile(id: string): Promise<{
        stream: import("mongodb").GridFSBucketReadStream;
        filename: string;
        contentType: string;
    }>;
    deleteFile(id: string): Promise<{
        message: string;
    }>;
}
