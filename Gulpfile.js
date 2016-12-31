// From https://jonsuh.com/blog/integrating-react-with-gulp/
var gulp         = require('gulp');
var autoprefixer = require('gulp-autoprefixer');
var babel        = require('gulp-babel');
var browserSync  = require('browser-sync');
var concat       = require('gulp-concat');
var eslint       = require('gulp-eslint');
var filter       = require('gulp-filter');
var newer        = require('gulp-newer');
var notify       = require('gulp-notify');
var plumber      = require('gulp-plumber');
var reload       = browserSync.reload;
var sass         = require('gulp-sass');
var sourcemaps   = require('gulp-sourcemaps');
var webpack      = require('webpack-stream');
var debug        = require('gulp-debug');
var path         = require('path');

var onError = function(err) {
  notify.onError({
    title:    "Error",
    message:  "<%= error %>",
  })(err);
  this.emit('end');
};

var env = {};

var plumberOptions = {
  errorHandler: onError,
};

var jsFiles = [
  'assets/js/src/**/*.js',
  'assets/js/src/**/*.jsx'
];

// Lint JS/JSX files
gulp.task('eslint', function() {
  return gulp.src(jsFiles)
    .pipe(eslint({
      baseConfig: {
        "ecmaFeatures": {
           "jsx": true
         }
      }
    }))
    .pipe(eslint.format())
    .pipe(eslint.failAfterError());
});

var copy = function(source, target) {
  return gulp.src(source)
    .pipe(newer(target))
    .pipe(gulp.dest(path.dirname(target)));
}

gulp.task('copy-bootstrap', function() {
  return copy('node_modules/bootstrap/dist/css/bootstrap.css', 'assets/css/vendor/bootstrap.css');
});
gulp.task('copy-bootstrap-theme', function() {
  return copy('node_modules/bootstrap/dist/css/bootstrap-theme.css', 'assets/css/vendor/bootstrap-theme.css');
});

// Concatenate jsFiles.vendor and jsFiles into one JS file.
gulp.task('concat-js', ['eslint'], function() {
  return gulp.src(jsFiles)
    .pipe(webpack({
        devtool: 'source-map',
        module: {
            loaders: [{
                test: /.jsx?$/,
                loader: 'babel-loader',
                exclude: /node_modules/,
            }]
        },
        output: {
            filename: 'App.js'
        }
    }))
    .pipe(gulp.dest('assets/js'));
});

// Compile Sass to CSS
gulp.task('sass', function() {
  var autoprefixerOptions = {
    browsers: ['last 2 versions'],
  };

  var filterOptions = '**/*.css';

  var reloadOptions = {
    stream: true,
  };

  var sassOptions = {
    includePaths: [

    ]
  };

  return gulp.src('assets/sass/**/*.scss')
    .pipe(plumber(plumberOptions))
    .pipe(sourcemaps.init())
    .pipe(sass(sassOptions))
    .pipe(autoprefixer(autoprefixerOptions))
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest('assets/css/src'))
    .pipe(filter(filterOptions))
    .pipe(reload(reloadOptions));
});

// Concatenate jsFiles.vendor and jsFiles into one JS file.
// Run copy-react and eslint before concatenating
gulp.task('concat-css', ['sass', 'copy-bootstrap', 'copy-bootstrap-theme'], function() {
  return gulp.src(['assets/css/vendor/**/*.css', 'assets/css/src/App.css'])
    .pipe(sourcemaps.init())
    .pipe(concat('App.css'))
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest('assets/css'));
});

// Watch JS/JSX and Sass files
gulp.task('watch', function() {
  gulp.watch(jsFiles, ['concat-js']);
  gulp.watch('assets/sass/**/*.scss', ['concat-css']);
});

// BrowserSync
gulp.task('browsersync', function() {
  browserSync({
    server: {
      baseDir: './'
    },
    open: false,
    online: false,
    notify: false,
  });
});

gulp.task('build', ['sass', 'concat-js', 'concat-css']);
gulp.task('default', ['build', 'browsersync', 'watch']);
