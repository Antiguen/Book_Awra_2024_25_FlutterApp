"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const core_1 = require("@nestjs/core");
const app_module_1 = require("./app.module");
const swagger_1 = require("@nestjs/swagger");
const cloudinary = require("cloudinary");
const common_1 = require("@nestjs/common");
async function bootstrap() {
    const app = await core_1.NestFactory.create(app_module_1.AppModule);
    app.useGlobalPipes(new common_1.ValidationPipe());
    app.enableCors({
        origin: true,
        methods: 'GET,HEAD,PUT,PATCH,POST,DELETE,OPTIONS',
        preflightContinue: false,
        optionsSuccessStatus: 204,
        credentials: true,
        allowedHeaders: [
            'Origin',
            'X-Requested-With',
            'Content-Type',
            'Accept',
            'Authorization',
            'Access-Control-Allow-Origin',
            'Access-Control-Allow-Credentials'
        ],
        exposedHeaders: ['Access-Control-Allow-Origin', 'Access-Control-Allow-Credentials'],
    });
    cloudinary.v2.config({
        cloud_name: 'dcixfqemc',
        api_key: '443894683639552',
        api_secret: 'bhj1-SWNgJSdjnFZE7Yv0jFqTMs',
    });
    const config = new swagger_1.DocumentBuilder()
        .setTitle('AfrotuneAPI')
        .setDescription('API documentation for the Students service')
        .setVersion('1.0')
        .addBearerAuth()
        .addTag('students')
        .build();
    const document = swagger_1.SwaggerModule.createDocument(app, config);
    swagger_1.SwaggerModule.setup('api', app, document);
    await app.listen(3006);
}
bootstrap();
//# sourceMappingURL=main.js.map