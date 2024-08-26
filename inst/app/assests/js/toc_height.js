function adjustTOCHeight() {
    var tocContainer = document.querySelector('#page-toc-container');
    var tocHeight = tocContainer.querySelector('#page-toc').scrollHeight;
    var tocPadBot = parseFloat(getComputedStyle(document.documentElement).fontSize) * 3;
    tocContainer.style.height = (tocHeight + tocPadBot) + 'px';  
} 
/* Run the function when the page loads */ 
window.addEventListener('load', adjustTOCHeight); 
/* Run the function when the window is resized */ 
window.addEventListener('resize', adjustTOCHeight);
