//import express
const express = require('express')

//init express router
const router = express.Router();

//import post controller
const postController = require('../controllers/PostController');

//define route for posts
router.get('/posts', postController.findPosts);

//export router
module.exports = router