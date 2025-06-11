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
Object.defineProperty(exports, "__esModule", { value: true });
exports.SongSchema = exports.Song = void 0;
const mongoose_1 = require("@nestjs/mongoose");
const mongoose_2 = require("mongoose");
let Song = class Song extends mongoose_2.Document {
};
exports.Song = Song;
__decorate([
    (0, mongoose_1.Prop)({ required: true }),
    __metadata("design:type", String)
], Song.prototype, "title", void 0);
__decorate([
    (0, mongoose_1.Prop)({ required: true }),
    __metadata("design:type", String)
], Song.prototype, "artist", void 0);
__decorate([
    (0, mongoose_1.Prop)({ required: true }),
    __metadata("design:type", String)
], Song.prototype, "album", void 0);
__decorate([
    (0, mongoose_1.Prop)({ required: true }),
    __metadata("design:type", String)
], Song.prototype, "genre", void 0);
__decorate([
    (0, mongoose_1.Prop)(),
    __metadata("design:type", String)
], Song.prototype, "description", void 0);
__decorate([
    (0, mongoose_1.Prop)({ required: true, type: Buffer }),
    __metadata("design:type", Buffer)
], Song.prototype, "songData", void 0);
__decorate([
    (0, mongoose_1.Prop)({ required: true }),
    __metadata("design:type", String)
], Song.prototype, "songContentType", void 0);
__decorate([
    (0, mongoose_1.Prop)({ required: true, type: Buffer }),
    __metadata("design:type", Buffer)
], Song.prototype, "imageData", void 0);
__decorate([
    (0, mongoose_1.Prop)({ required: true }),
    __metadata("design:type", String)
], Song.prototype, "imageContentType", void 0);
__decorate([
    (0, mongoose_1.Prop)({ default: Date.now }),
    __metadata("design:type", Date)
], Song.prototype, "uploadDate", void 0);
exports.Song = Song = __decorate([
    (0, mongoose_1.Schema)()
], Song);
exports.SongSchema = mongoose_1.SchemaFactory.createForClass(Song);
exports.SongSchema.index({ title: 1, artist: 1 }, {
    unique: true,
    collation: { locale: 'en', strength: 2 }
});
//# sourceMappingURL=song.schema.js.map