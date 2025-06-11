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
exports.ProfileController = void 0;
const common_1 = require("@nestjs/common");
const platform_express_1 = require("@nestjs/platform-express");
const profile_service_1 = require("./profile.service");
const create_profile_dto_1 = require("../dto/create-profile.dto");
const auth_guard_1 = require("../guard/auth.guard");
const swagger_1 = require("@nestjs/swagger");
const profile_schema_1 = require("../schemas/profile.schema");
const auth2_guard_1 = require("../guard/auth2.guard");
const user_service_1 = require("../user/user.service");
const common_2 = require("@nestjs/common");
let ProfileController = class ProfileController {
    constructor(profileService, userService) {
        this.profileService = profileService;
        this.userService = userService;
    }
    async uploadProfile(req, createProfileDto, files) {
        const decodedData = req.decodedData;
        if (!decodedData) {
            throw new common_1.BadRequestException('Unable to validate user credentials.');
        }
        const { role, id, email } = decodedData;
        console.log('Decoded Data:', decodedData);
        console.log('User Role:', role);
        if (!files?.imageData?.[0]) {
            throw new common_1.BadRequestException('Image file is required.');
        }
        const imageFile = files.imageData[0];
        const profileData = {
            ...createProfileDto,
            userId: id,
            email: email,
            imageData: imageFile.buffer,
            imageContentType: imageFile.mimetype,
        };
        console.log('Profile Data:', profileData);
        try {
            const result = await this.profileService.create(profileData);
            return {
                success: true,
                message: 'Profile uploaded successfully',
                data: {
                    email: result.email,
                    bio: result.bio,
                    genre: result.genre,
                    description: result.description,
                },
            };
        }
        catch (error) {
            console.error('Error while saving profile:', error);
            throw new common_1.BadRequestException('Failed to save profile: ' + error.message);
        }
    }
    async updateProfileByEmail(email, createProfileDto, files) {
        const imageFile = files?.imageData?.[0];
        if (!imageFile) {
            throw new common_1.BadRequestException('Image file is required.');
        }
        const updatedProfileData = {
            ...createProfileDto,
            imageData: imageFile.buffer,
            imageContentType: imageFile.mimetype,
        };
        const updatedProfile = await this.profileService.updateProfileByEmail(email, updatedProfileData);
        if (!updatedProfile) {
            throw new common_1.NotFoundException('Profile not found for the given email');
        }
        return {
            success: true,
            message: 'Profile updated successfully',
        };
    }
    async findByArtist(email) {
        const profile = await this.profileService.findByArtist(email);
        if (!profile) {
            throw new common_1.NotFoundException('Profile not found for this artist');
        }
        return profile;
    }
    async findProfileWithSongs(email) {
        const result = await this.profileService.findProfileWithSongs(email);
        if (!result.profile) {
            throw new common_1.NotFoundException('Profile not found for this artist');
        }
        return result;
    }
    async getProfile(req) {
        const email = req.decodedData?.email || req.user?.email;
        const user = await this.userService.findByEmail(email);
        if (!user)
            throw new common_1.NotFoundException('User not found');
        return user;
    }
};
exports.ProfileController = ProfileController;
__decorate([
    (0, common_1.Post)('upload'),
    (0, common_1.UseGuards)(auth_guard_1.AuthGuard),
    (0, swagger_1.ApiBearerAuth)(),
    (0, swagger_1.ApiConsumes)('multipart/form-data'),
    (0, common_1.UseInterceptors)((0, platform_express_1.FileFieldsInterceptor)([
        { name: 'imageData', maxCount: 1 },
    ])),
    __param(0, (0, common_1.Req)()),
    __param(1, (0, common_1.Body)()),
    __param(2, (0, common_1.UploadedFiles)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object, create_profile_dto_1.CreateProfileDto, Object]),
    __metadata("design:returntype", Promise)
], ProfileController.prototype, "uploadProfile", null);
__decorate([
    (0, common_1.Put)('updateprofile/:email'),
    (0, common_1.UseGuards)(auth_guard_1.AuthGuard),
    (0, swagger_1.ApiBearerAuth)(),
    (0, swagger_1.ApiConsumes)('multipart/form-data'),
    (0, common_1.UseInterceptors)((0, platform_express_1.FileFieldsInterceptor)([
        { name: 'imageData', maxCount: 1 },
    ])),
    (0, swagger_1.ApiResponse)({ status: 200, description: 'Profile updated successfully' }),
    (0, swagger_1.ApiResponse)({ status: 404, description: 'Profile not found' }),
    __param(0, (0, common_1.Param)('email')),
    __param(1, (0, common_1.Body)()),
    __param(2, (0, common_1.UploadedFiles)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String, create_profile_dto_1.CreateProfileDto, Object]),
    __metadata("design:returntype", Promise)
], ProfileController.prototype, "updateProfileByEmail", null);
__decorate([
    (0, common_1.Get)(':email'),
    (0, swagger_1.ApiResponse)({ status: 200, description: 'Profile found', type: profile_schema_1.Profile }),
    (0, swagger_1.ApiResponse)({ status: 404, description: 'Profile not found' }),
    __param(0, (0, common_1.Param)('email')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], ProfileController.prototype, "findByArtist", null);
__decorate([
    (0, common_1.Get)(':email/songs'),
    (0, swagger_1.ApiBearerAuth)(),
    (0, swagger_1.ApiResponse)({ status: 200, description: 'Profile and songs found', type: Object }),
    (0, swagger_1.ApiResponse)({ status: 404, description: 'Profile not found or songs not found' }),
    __param(0, (0, common_1.Param)('email')),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [String]),
    __metadata("design:returntype", Promise)
], ProfileController.prototype, "findProfileWithSongs", null);
__decorate([
    (0, common_1.Get)('me'),
    (0, common_1.UseGuards)(auth2_guard_1.AuthenticatedGuard),
    __param(0, (0, common_1.Req)()),
    __metadata("design:type", Function),
    __metadata("design:paramtypes", [Object]),
    __metadata("design:returntype", Promise)
], ProfileController.prototype, "getProfile", null);
exports.ProfileController = ProfileController = __decorate([
    (0, swagger_1.ApiTags)('profile'),
    (0, common_1.Controller)('profile'),
    __param(1, (0, common_2.Inject)((0, common_2.forwardRef)(() => user_service_1.UserService))),
    __metadata("design:paramtypes", [profile_service_1.ProfileService,
        user_service_1.UserService])
], ProfileController);
//# sourceMappingURL=profile.controller.js.map