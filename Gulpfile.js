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
var browserify   = require('gulp-browserify');
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

var jsFiles = {
  vendor: [

  ],
  source: [
    'assets/js/src/App.js'
  ]
};

// Lint JS/JSX files
gulp.task('eslint', function() {
  return gulp.src(jsFiles.source)
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
// Copy react.js and react-dom.js to assets/js/src/vendor
// only if the copy in node_modules is "newer"
gulp.task('copy-react', function() {
  return copy('node_modules/react/dist/react.js', 'assets/js/src/vendor/react.js');
});
gulp.task('copy-react-dom', function() {
  return copy('node_modules/react-dom/dist/react-dom.js', 'assets/js/src/vendor/react-dom.js');
});
gulp.task('copy-react-bootstrap', function() {
  return copy('node_modules/react-bootstrap/dist/react-bootstrap.js', 'assets/js/src/vendor/react-bootstrap.js');
});
gulp.task('copy-bootstrap', function() {
  return copy('node_modules/bootstrap/dist/css/bootstrap.css', 'assets/css/src/vendor/bootstrap.css');
});
gulp.task('copy-bootstrap-theme', function() {
  return copy('node_modules/bootstrap/dist/css/bootstrap-theme.css', 'assets/css/src/vendor/bootstrap-theme.css');
});

// Concatenate jsFiles.vendor and jsFiles.source into one JS file.
// Run copy-react and eslint before concatenating
gulp.task('concat-js', ['copy-react', 'copy-react-dom', 'copy-react-bootstrap', 'eslint'], function() {
  return gulp.src(jsFiles.vendor.concat(jsFiles.source))
    .pipe(sourcemaps.init())
    .pipe(babel({
      compact: false
    }))
    .pipe(concat('App.js'))
    .pipe(browserify({
        insertGlobals: true,
        debug: !env.production
    }))
    .pipe(sourcemaps.write('./'))
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

// Concatenate jsFiles.vendor and jsFiles.source into one JS file.
// Run copy-react and eslint before concatenating
gulp.task('concat-css', ['sass', 'copy-bootstrap', 'copy-bootstrap-theme'], function() {
  return gulp.src(['assets/css/src/vendor/**/*.css', 'assets/css/src/App.css'])
    .pipe(sourcemaps.init())
    .pipe(concat('App.css'))
    .pipe(sourcemaps.write('./'))
    .pipe(gulp.dest('assets/css'));
});

// Watch JS/JSX and Sass files
gulp.task('watch', function() {
  gulp.watch('assets/js/src/**/*.{js,jsx}', ['concat-js']);
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
