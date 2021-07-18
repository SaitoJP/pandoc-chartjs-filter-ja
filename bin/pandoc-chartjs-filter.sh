#!/usr/bin/env node
"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __generator = (this && this.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (_) try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
var pandoc_filter_1 = require("pandoc-filter");
var yaml_1 = require("yaml");
var fs_1 = __importDefault(require("fs"));
var chartjs_node_canvas_1 = require("chartjs-node-canvas");
var uuid_1 = require("uuid");
var CHART_CODE_BLOCK_TAG = 'chart';
var isChartCodeBlock = function (_a) {
    var id = _a[0], classes = _a[1], keyVal = _a[2];
    return (id === CHART_CODE_BLOCK_TAG || (classes.length === 1 && classes[0] === CHART_CODE_BLOCK_TAG));
};
var getMetadata = function (attr) {
    var attrList = attr[2];
    var metadataRaw = attrList.reduce(function (result, _a) {
        var key = _a[0], value = _a[1];
        result[key] = value;
        return result;
    }, {});
    var metadata = {};
    // TODO FK magic numbers/strings to default values (metadata default)
    metadata.width = typeof metadataRaw.width !== 'undefined' ? parseInt(metadataRaw.width) || 400 : 400;
    metadata.height = typeof metadataRaw.height !== 'undefined' ? parseInt(metadataRaw.height) || 400 : 400;
    metadata.out = metadataRaw.out || ".";
    return metadata;
};
var generateChartImageBySpec = function (_a, chartSpec) {
    var width = _a.width, height = _a.height, out = _a.out;
    return __awaiter(void 0, void 0, void 0, function () {
        var canvas, imageUri, stream;
        return __generator(this, function (_b) {
            switch (_b.label) {
                case 0:
                    canvas = new chartjs_node_canvas_1.ChartJSNodeCanvas({ width: width, height: height });
                    imageUri = out + "/chart-" + uuid_1.v4() + ".png";
                    return [4 /*yield*/, canvas.renderToStream(chartSpec)
                            .pipe(fs_1.default.createWriteStream(imageUri))];
                case 1:
                    stream = _b.sent();
                    return [2 /*return*/, imageUri];
            }
        });
    });
};
var chartJsFilter = function (element) { return __awaiter(void 0, void 0, void 0, function () {
    var _a, _b, attr, codeBlockText, metadata, chartSpec, imageUri, inlineElements;
    return __generator(this, function (_c) {
        switch (_c.label) {
            case 0:
                _a = element.t;
                switch (_a) {
                    case 'CodeBlock': return [3 /*break*/, 1];
                }
                return [3 /*break*/, 3];
            case 1:
                _b = element.c, attr = _b[0], codeBlockText = _b[1];
                if (!isChartCodeBlock(attr)) {
                    return [2 /*return*/];
                }
                metadata = getMetadata(attr);
                chartSpec = yaml_1.parse(codeBlockText);
                return [4 /*yield*/, generateChartImageBySpec(metadata, chartSpec)
                        .catch(function (e) {
                        return 'https://dummyimage.com/600x400/ffffff/f00000&text=ERROR';
                    })];
            case 2:
                imageUri = _c.sent();
                inlineElements = [pandoc_filter_1.Image(['', [], []], [], [imageUri, ''])];
                return [2 /*return*/, pandoc_filter_1.Para(inlineElements)];
            case 3: return [2 /*return*/];
        }
    });
}); };
pandoc_filter_1.stdio(chartJsFilter);
