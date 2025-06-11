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
exports.UserController = void 0;
const common_1 = require("@nestjs/common");
const auth2_guard_1 = require("../guard/auth2.guard");
const user_service_1 = require("./user.service");
const swagger_1 = require("@nestjs/swagger");
const platform_express_1 = require("@nestjs/platform-express");
const decorators_1 = require("@nestjs/common/decorators");
let UserController = class UserController {
    constructor(userService) {
        this.userService = userService;
    }
    async getMe(req) {
        const email = req.decodedData?.email || req.user?.email;
        const user = await this.userService.findByEmail(email);
        if (!user)
            throw new common_1.NotFoundException('User not found');
        return user;
    }
    async addToLibrary(req, bookId) {
        const email = req.decodedData?.email || req.user?.email;
        const user = await this.userService.findByEmail(email);
        if (!user)
            throw new common_1.NotFoundException('User not found');
        if (!user.library)
            user.library = [];
        if (!user.library.includes(bookId)) {
            user.library.push(bookId);
            await user.save();
        }
        return { library: user.library };
    }
    async removeFromLibrary(req, bookId) {
        const email = req.decodedData?.email || req.user?.email;
        const user = await this.userService.findByEmail(email);
        if (!user)
            throw new common_1.NotFoundException('User not found');
        if (!user.library)
            user.library = [];
        user.library = user.library.filter(id => id !== bookId);
        await user.save();
        return { library: user.library };
    }
    async updateMe(req, body, image) {
        const email = req.decodedData?.email || req.user?.email;
        const user = await this.userService.findByEmail(email);
        if (!user)
            throw new common_1.NotFoundException('User not found');
        user.fullName = body.fullName ?? user.fullName;
        user.bio = body.bio ?? user.bio;
        user.genre = body.genre ?? user.genre;
        user.description = body.description ?? user.description;
        if (image) {
            user.imageData = image.buffer;
            user.imageContentType = image.mimetype;
        }
        await user.save();
        return user;
    }
};
exports.UserController = UserController;
__decorate([
    (0, common_1.Get)('me'),
    (0, common_1.UseGuards)(auth2_guard_1.AuthenticatedGuard),
    __param(0, (0, common_1.Req)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], UserController.prototype, "getMe", null);
__decorate([
    (0, common_1.Put)('library/add'),
    (0, common_1.UseGuards)(auth2_guard_1.AuthenticatedGuard),
    __param(0, (0, common_1.Req)()),
    __param(1, (0, common_1.Body)('bookId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String]),
    __metadata("design:returntype", Promise)
], UserController.prototype, "addToLibrary", null);
__decorate([
    (0, common_1.Put)('library/remove'),
    (0, common_1.UseGuards)(auth2_guard_1.AuthenticatedGuard),
    __param(0, (0, common_1.Req)()),
    __param(1, (0, common_1.Body)('bookId')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, String]),
    __metadata("design:returntype", Promise)
], UserController.prototype, "removeFromLibrary", null);
__decorate([
    (0, common_1.Put)('me'),
    (0, common_1.UseGuards)(auth2_guard_1.AuthenticatedGuard),
    (0, decorators_1.UseInterceptors)((0, platform_express_1.FileInterceptor)('image')),
    __param(0, (0, common_1.Req)()),
    __param(1, (0, common_1.Body)()),
    __param(2, (0, decorators_1.UploadedFile)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, Object, Object]),
    __metadata("design:returntype", Promise)
], UserController.prototype, "updateMe", null);
exports.UserController = UserController = __decorate([
    (0, swagger_1.ApiTags)('users'),
    (0, common_1.Controller)('users'),
    __metadata("design:paramtypes", [user_service_1.UserService])
], UserController);
//# sourceMappingURL=user.controller.js.map