// ===== DesiBites JavaScript =====

// Smooth scroll animation for navigation links
document.addEventListener('DOMContentLoaded', function() {
    
    // Add active class to current page navigation
    const currentPage = window.location.pathname.split('/').pop() || 'index.html';
    const navLinks = document.querySelectorAll('.nav-links a');
    
    navLinks.forEach(link => {
        const linkPage = link.getAttribute('href');
        if (linkPage === currentPage) {
            link.classList.add('active');
        }
    });

    // Add fade-in animation to food cards
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver(function(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, observerOptions);

    // Observe all food cards
    const foodCards = document.querySelectorAll('.food-card');
    foodCards.forEach(card => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(20px)';
        card.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        observer.observe(card);
    });

    // Observe detail card
    const detailCard = document.querySelector('.detail-card');
    if (detailCard) {
        detailCard.style.opacity = '0';
        detailCard.style.transform = 'translateY(20px)';
        detailCard.style.transition = 'opacity 0.8s ease, transform 0.8s ease';
        observer.observe(detailCard);
    }

    // Lazy loading fallback for older browsers
    if ('loading' in HTMLImageElement.prototype) {
        // Browser supports lazy loading
        console.log('Native lazy loading supported');
    } else {
        // Fallback for browsers that don't support lazy loading
        const images = document.querySelectorAll('img[loading="lazy"]');
        images.forEach(img => {
            img.src = img.src;
        });
    }

    // Add hover effect enhancement
    const cards = document.querySelectorAll('.food-card');
    cards.forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.background = '#FFF7F0';
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.background = '#FFFFFF';
        });
    });

    console.log('DesiBites website loaded successfully!');
});
