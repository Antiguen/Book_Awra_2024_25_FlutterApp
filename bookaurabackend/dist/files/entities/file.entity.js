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
exports.FileSchema = exports.File = void 0;
const mongoose_1 = require("@nestjs/mongoose");
const mongoose_2 = require("mongoose");
let File = class File extends mongoose_2.Document {
};
exports.File = File;
__decorate([
    (0, mongoose_1.Prop)(),
    __metadata("design:type", String)
], File.prototype, "filename", void 0);
__decorate([
    (0, mongoose_1.Prop)(),
    __metadata("design:type", String)
], File.prototype, "contentType", void 0);
__decorate([
    (0, mongoose_1.Prop)(),
    __metadata("design:type", Number)
], File.prototype, "length", void 0);
__decorate([
    (0, mongoose_1.Prop)(),
    __metadata("design:type", Date)
], File.prototype, "uploadDate", void 0);
exports.File = File = __decorate([
    (0, mongoose_1.Schema)()
], File);
exports.FileSchema = mongoose_1.SchemaFactory.createForClass(File);
//# sourceMappingURL=file.entity.js.map