var url = "/resume.pdf";
var canvas = document.getElementById("resume");

var PAGE = 1;
var SCALE = 1.0;

var pdfjs = window['pdfjs-dist/build/pdf'];
pdfjs.GlobalWorkerOptions.workerSrc
    = "https://cdnjs.cloudflare.com/ajax/libs/pdf.js/2.0.489/pdf.worker.min.js";

// Asynchronous download of PDF
var loadingTask = pdfjs.getDocument(url);
loadingTask.promise.then(function(pdf) {
  console.log('PDF loaded');
  
  // Fetch the first page
  var pageNumber = 1;
  pdf.getPage(pageNumber).then(function(page) {
    console.log('Page loaded');
    
    var viewport = page.getViewport(SCALE);

    // Prepare canvas using PDF page dimensions
    var context = canvas.getContext('2d');
    canvas.height = viewport.height;
    canvas.width = viewport.width;

    // Render PDF page into canvas context
    var renderContext = {
      canvasContext: context,
      viewport: viewport
    };
    var renderTask = page.render(renderContext);
    renderTask.then(function () {
      console.log('Page rendered');
    });
  });
}, function (reason) {
  // PDF loading error
  console.error(reason);
});
