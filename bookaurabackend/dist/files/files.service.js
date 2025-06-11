"use strict";
var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __param = (this && this.__param) || function (paramIndex, decorator) {
    return function (target, key) { decorator(target, key, paramIndex); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.FilesService = void 0;
const common_1 = require("@nestjs/common");
const mongoose_1 = require("@nestjs/mongoose");
const mongoose_2 = require("mongoose");
const mongodb_1 = require("mongodb");
let FilesService = class FilesService {
    constructor(connection) {
        this.connection = connection;
        this.bucket = new mongodb_1.GridFSBucket(this.connection.db);
    }
    async uploadFile(file) {
        const uploadStream = this.bucket.openUploadStream(file.originalname, {
            contentType: file.mimetype,
        });
        return new Promise((resolve, reject) => {
            const bufferStream = require('stream').Readable.from(file.buffer);
            bufferStream.pipe(uploadStream)
                .on('error', reject)
                .on('finish', () => {
                resolve({
                    id: uploadStream.id,
                    filename: file.originalname,
                    contentType: file.mimetype,
                    size: file.size,
                });
            });
        });
    }
    async getFiles() {
        const files = await this.bucket.find().toArray();
        return files;
    }
    async downloadFile(id) {
        try {
            const files = await this.bucket.find({ _id: new mongodb_1.ObjectId(id) }).toArray();
            if (!files.length) {
                throw new common_1.NotFoundException('File not found');
            }
            const downloadStream = this.bucket.openDownloadStream(new mongodb_1.ObjectId(id));
            return {
                stream: downloadStream,
                filename: files[0].filename,
                contentType: files[0].contentType
            };
        }
        catch (error) {
            throw new common_1.NotFoundException('File not found');
        }
    }
    async deleteFile(id) {
        try {
            await this.bucket.delete(new mongodb_1.ObjectId(id));
            return { message: 'File deleted successfully' };
        }
        catch (error) {
            throw new common_1.NotFoundException('File not found');
        }
    }
};
exports.FilesService = FilesService;
exports.FilesService = FilesService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, mongoose_1.InjectConnection)()),
    __metadata("design:paramtypes", [mongoose_2.Connection])
], FilesService);
//# sourceMappingURL=files.service.js.map