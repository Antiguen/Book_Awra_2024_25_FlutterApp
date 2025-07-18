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
exports.AuthenticatedGuard = void 0;
const common_1 = require("@nestjs/common");
const auth_service_1 = require("../auth/auth.service");
let AuthenticatedGuard = class AuthenticatedGuard {
    constructor(authService) {
        this.authService = authService;
    }
    async canActivate(context) {
        try {
            const request = context.switchToHttp().getRequest();
            const { authorization } = request.headers;
            console.log("Headers:", request.headers);
            if (!authorization)
                throw new common_1.UnauthorizedException("No token");
            const authToken = authorization.replace(/bearer /i, "").trim();
            const decodedData = await this.authService.validateToken(authToken);
            request.decodedData = decodedData;
            return true;
        }
        catch (error) {
            throw new common_1.UnauthorizedException(error.message || "Session expired! Please sign in");
        }
    }
};
exports.AuthenticatedGuard = AuthenticatedGuard;
exports.AuthenticatedGuard = AuthenticatedGuard = __decorate([
    (0, common_1.Injectable)(),
    __metadata("design:paramtypes", [auth_service_1.AuthService])
], AuthenticatedGuard);
//# sourceMappingURL=auth2.guard.js.map