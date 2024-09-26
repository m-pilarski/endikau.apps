function adjustTOCHeight() {
    var tocContainer = document.querySelector('#page-toc-container');
    var tocHeight = tocContainer.querySelector('#page-toc').scrollHeight;
    tocContainer.style.height = tocHeight + 'px';
}
window.addEventListener('load', adjustTOCHeight);
window.addEventListener('resize', adjustTOCHeight);
