function adjustNavbarSpacer() {
	var navbarContainer = document.querySelector('#page-navbar');
	var navbarSpacer = document.querySelector('#page-navbar-spacer');
	var navbarHeight = navbarContainer.scrollHeight;
	navbarSpacer.style.height = navbarHeight + 'px';
}

window.addEventListener('load', adjustNavbarSpacer);
window.addEventListener('resize', adjustNavbarSpacer);

/*
const navbarToggle = document.querySelector('#navbarSupportedContent') 
navbarToggle.addEventListener('shown.bs.collapse', adjustNavbarSpacer) 
navbarToggle.addEventListener('hidden.bs.collapse', adjustNavbarSpacer) 
*/
