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
exports.AuthGuard = void 0;
const common_1 = require("@nestjs/common");
const auth_service_1 = require("../auth/auth.service");
const user_role_enum_1 = require("../schemas/user-role.enum");
let AuthGuard = class AuthGuard {
    constructor(authService) {
        this.authService = authService;
    }
    async canActivate(context) {
        try {
            const request = context.switchToHttp().getRequest();
            const { authorization } = request.headers;
            if (!authorization || authorization.trim() === '') {
                throw new common_1.UnauthorizedException('Please provide a token');
            }
            const authToken = authorization.replace(/bearer/gim, '').trim();
            const decodedData = await this.authService.validateToken(authToken);
            const userRole = decodedData.role;
            console.log('User Details:', {
                token: authToken,
                user: decodedData,
                role: userRole,
            });
            request.decodedData = decodedData;
            if (userRole !== user_role_enum_1.UserRole.ARTIST && userRole !== user_role_enum_1.UserRole.SUPER_ADMIN) {
                throw new common_1.ForbiddenException('Insufficient permissions');
            }
            return true;
        }
        catch (error) {
            console.log('Auth error:', error.message);
            throw new common_1.ForbiddenException(error.message || 'Session expired! Please sign in');
        }
    }
};
exports.AuthGuard = AuthGuard;
exports.AuthGuard = AuthGuard = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [auth_service_1.AuthService])
], AuthGuard);
//# sourceMappingURL=auth.guard.js.map