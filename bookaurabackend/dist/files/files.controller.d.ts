import { FilesService } from './files.service';
import { Response } from 'express';
export declare class FilesController {
    private readonly filesService;
    constructor(filesService: FilesService);
    uploadFile(file: Express.Multer.File): Promise<unknown>;
    getFiles(): Promise<import("mongodb").GridFSFile[]>;
    downloadFile(id: string, res: Response): Promise<void>;
    deleteFile(id: string): Promise<{
        message: string;
    }>;
}
