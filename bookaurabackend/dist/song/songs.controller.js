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
exports.SongsController = void 0;
const common_1 = require("@nestjs/common");
const platform_express_1 = require("@nestjs/platform-express");
const songs_service_1 = require("./songs.service");
const create_songeDto_1 = require("../dto/create-songeDto");
const swagger_1 = require("@nestjs/swagger");
let SongsController = class SongsController {
    constructor(songsService) {
        this.songsService = songsService;
    }
    async uploadSong(createSongDto, files) {
        if (!files?.song?.[0] || !files?.image?.[0]) {
            throw new common_1.BadRequestException('Both song and image files are required');
        }
        const songFile = files.song[0];
        const imageFile = files.image[0];
        try {
            const result = await this.songsService.create({
                ...createSongDto,
                songData: songFile.buffer,
                songContentType: songFile.mimetype,
                imageData: imageFile.buffer,
                imageContentType: imageFile.mimetype
            });
            return {
                success: true,
                message: 'Song uploaded successfully',
                data: {
                    id: result._id,
                    title: result.title,
                    artist: result.artist
                }
            };
        }
        catch (error) {
            throw new common_1.BadRequestException(error.message);
        }
    }
    async getAllSongs() {
        return this.songsService.findAll();
    }
    async streamSong(id, res) {
        const song = await this.songsService.findById(id);
        if (!song) {
            throw new common_1.NotFoundException('Song not found');
        }
        res.set({
            'Content-Type': song.songContentType,
            'Content-Disposition': `inline; filename="${song.title}.mp3"`,
        });
        res.send(song.songData);
    }
    async getImage(id, res) {
        const song = await this.songsService.findById(id);
        if (!song) {
            throw new common_1.NotFoundException('Song not found');
        }
        res.set({
            'Content-Type': song.imageContentType,
            'Content-Disposition': `inline; filename="${song.title}-image"`,
        });
        res.send(song.imageData);
    }
    async getSongsByTitle(title) {
        if (!title) {
            throw new common_1.BadRequestException('Title query parameter is required');
        }
        return this.songsService.findByTitle(title);
    }
    async getSongsByArtist(artist) {
        if (!artist) {
            throw new common_1.BadRequestException('Artist parameter is required');
        }
        return this.songsService.findByArtist(artist);
    }
    async getSongById(id) {
        const song = await this.songsService.findById(id);
        if (!song)
            throw new common_1.NotFoundException('Song not found');
        return song;
    }
    async getSongPdf(id, res) {
        const { data, contentType } = await this.songsService.getSongData(id);
        if (!data) {
            throw new common_1.NotFoundException('PDF not found');
        }
        res.setHeader('Content-Type', contentType || 'application/pdf');
        res.send(data);
    }
};
exports.SongsController = SongsController;
__decorate([
    (0, common_1.Post)('upload'),
    (0, swagger_1.ApiConsumes)('multipart/form-data'),
    (0, common_1.UseInterceptors)((0, platform_express_1.FileFieldsInterceptor)([
        { name: 'song', maxCount: 1 },
        { name: 'image', maxCount: 1 }
    ])),
    (0, swagger_1.ApiBody)({
        schema: {
            type: 'object',
            properties: {
                title: { type: 'string' },
                artist: { type: 'string' },
                album: { type: 'string' },
                genre: { type: 'string' },
                description: { type: 'string' },
                song: { type: 'string', format: 'binary' },
                image: { type: 'string', format: 'binary' }
            }
        }
    }),
    __param(0, (0, common_1.Body)()),
    __param(1, (0, common_1.UploadedFiles)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [create_songeDto_1.CreateSongDto, Object]),
    __metadata("design:returntype", Promise)
], SongsController.prototype, "uploadSong", null);
__decorate([
    (0, common_1.Get)(),
    (0, swagger_1.ApiOperation)({ summary: 'Get all songs' }),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", []),
    __metadata("design:returntype", Promise)
], SongsController.prototype, "getAllSongs", null);
__decorate([
    (0, common_1.Get)('stream/:id'),
    (0, swagger_1.ApiOperation)({ summary: 'Stream song audio' }),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Res)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, Object]),
    __metadata("design:returntype", Promise)
], SongsController.prototype, "streamSong", null);
__decorate([
    (0, common_1.Get)('image/:id'),
    (0, swagger_1.ApiOperation)({ summary: 'Get song image' }),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Res)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, Object]),
    __metadata("design:returntype", Promise)
], SongsController.prototype, "getImage", null);
__decorate([
    (0, common_1.Get)('search/title'),
    (0, swagger_1.ApiOperation)({ summary: 'Search songs by title' }),
    __param(0, (0, common_1.Query)('title')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], SongsController.prototype, "getSongsByTitle", null);
__decorate([
    (0, common_1.Get)('artist/:artist'),
    (0, swagger_1.ApiOperation)({ summary: 'Get songs by artist name' }),
    __param(0, (0, common_1.Param)('artist')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], SongsController.prototype, "getSongsByArtist", null);
__decorate([
    (0, common_1.Get)(':id'),
    __param(0, (0, common_1.Param)('id')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], SongsController.prototype, "getSongById", null);
__decorate([
    (0, common_1.Get)(':id/pdf'),
    __param(0, (0, common_1.Param)('id')),
    __param(1, (0, common_1.Res)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, Object]),
    __metadata("design:returntype", Promise)
], SongsController.prototype, "getSongPdf", null);
exports.SongsController = SongsController = __decorate([
    (0, swagger_1.ApiTags)('songs'),
    (0, common_1.Controller)('songs'),
    __metadata("design:paramtypes", [songs_service_1.SongsService])
], SongsController);
//# sourceMappingURL=songs.controller.js.map