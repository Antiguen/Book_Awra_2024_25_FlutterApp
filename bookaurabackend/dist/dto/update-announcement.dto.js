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
exports.UpdateAnnouncementDto = void 0;
const swagger_1 = require("@nestjs/swagger");
class UpdateAnnouncementDto {
}
exports.UpdateAnnouncementDto = UpdateAnnouncementDto;
__decorate([
    (0, swagger_1.ApiProperty)({ description: 'Title of the announcement' }),
    __metadata("design:type", String)
], UpdateAnnouncementDto.prototype, "title", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ description: 'Content of the announcement' }),
    __metadata("design:type", String)
], UpdateAnnouncementDto.prototype, "content", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ description: 'Category of the announcement' }),
    __metadata("design:type", String)
], UpdateAnnouncementDto.prototype, "category", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ description: 'Summary of the announcement' }),
    __metadata("design:type", String)
], UpdateAnnouncementDto.prototype, "summary", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ description: 'Date of the announcement' }),
    __metadata("design:type", Date)
], UpdateAnnouncementDto.prototype, "date", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ description: 'Image URL of the announcement' }),
    __metadata("design:type", String)
], UpdateAnnouncementDto.prototype, "image", void 0);
__decorate([
    (0, swagger_1.ApiProperty)({ description: 'Tags associated with the announcement' }),
    __metadata("design:type", String)
], UpdateAnnouncementDto.prototype, "tag", void 0);
//# sourceMappingURL=update-announcement.dto.js.map