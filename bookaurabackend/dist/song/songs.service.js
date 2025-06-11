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
exports.SongsService = void 0;
const common_1 = require("@nestjs/common");
const mongoose_1 = require("@nestjs/mongoose");
const mongoose_2 = require("mongoose");
const song_schema_1 = require("../schemas/song.schema");
let SongsService = class SongsService {
    constructor(songModel) {
        this.songModel = songModel;
    }
    async create(data) {
        try {
            const newSong = new this.songModel({
                title: data.title,
                artist: data.artist,
                album: data.album,
                genre: data.genre,
                description: data.description,
                songData: data.songData,
                songContentType: data.songContentType,
                imageData: data.imageData,
                imageContentType: data.imageContentType,
                uploadDate: new Date(),
            });
            return await newSong.save();
        }
        catch (error) {
            throw new common_1.BadRequestException(`Failed to save song: ${error.message}`);
        }
    }
    async findAll() {
        const songs = await this.songModel
            .find()
            .select("-songData")
            .sort({ uploadDate: -1 })
            .exec();
        return songs.map((song) => ({
            ...song.toObject(),
            imageData: song.imageData ? song.imageData.toString("base64") : null,
        }));
    }
    async findById(id) {
        const song = await this.songModel.findById(id).exec();
        if (!song)
            return null;
        const obj = song.toObject();
        return {
            ...obj,
            imageData: obj.imageData ? obj.imageData.toString("base64") : null,
        };
    }
    async findByTitle(title) {
        return this.songModel
            .find({
            title: { $regex: title, $options: "i" },
        })
            .select("-songData -imageData")
            .sort({ uploadDate: -1 })
            .exec();
    }
    async findByArtist(artist) {
        return this.songModel
            .find({
            artist: { $regex: artist, $options: "i" },
        })
            .select("-songData -imageData")
            .sort({ uploadDate: -1 })
            .exec();
    }
    async getSongData(id) {
        const song = await this.songModel
            .findById(id)
            .select("songData songContentType")
            .exec();
        if (!song) {
            throw new common_1.NotFoundException("Song not found");
        }
        return {
            data: song.songData,
            contentType: song.songContentType,
        };
    }
    async getImageData(id) {
        const song = await this.songModel
            .findById(id)
            .select("imageData imageContentType")
            .exec();
        if (!song) {
            throw new common_1.NotFoundException("Song not found");
        }
        return {
            data: song.imageData,
            contentType: song.imageContentType,
        };
    }
};
exports.SongsService = SongsService;
exports.SongsService = SongsService = __decorate([
    (0, common_1.Injectable)(),
    __param(0, (0, mongoose_1.InjectModel)(song_schema_1.Song.name)),
    __metadata("design:paramtypes", [mongoose_2.Model])
], SongsService);
//# sourceMappingURL=songs.service.js.map