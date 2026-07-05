// ==========================================
// MUHAMMAD ZUBAIR - PROFESSIONAL WEBSITE
// Single JavaScript file for ALL pages
// ==========================================

// Initialize Feather Icons
document.addEventListener('DOMContentLoaded', function() {
    feather.replace();
});

// ==========================================
// MOBILE MENU TOGGLE
// ==========================================
function toggleMenu() {
    const navLinks = document.getElementById('navLinks');
    const menuToggle = document.querySelector('.menu-toggle');
    const isActive = navLinks.classList.toggle('active');
    
    // Update ARIA attribute for accessibility
    menuToggle.setAttribute('aria-expanded', isActive);
    
    // Prevent body scroll when menu is open
    if (isActive) {
        document.body.style.overflow = 'hidden';
    } else {
        document.body.style.overflow = '';
    }
}

// ==========================================
// SMOOTH SCROLL FOR ANCHOR LINKS
// ==========================================
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        const href = this.getAttribute('href');
        
        // Skip if href is just "#"
        if (href === '#') {
            e.preventDefault();
            return;
        }
        
        const target = document.querySelector(href);
        if (target) {
            e.preventDefault();
            target.scrollIntoView({ 
                behavior: 'smooth',
                block: 'start'
            });
            
            // Close mobile menu if open
            const navLinks = document.getElementById('navLinks');
            if (navLinks && navLinks.classList.contains('active')) {
                navLinks.classList.remove('active');
                document.body.style.overflow = '';
                
                // Update ARIA attribute
                const menuToggle = document.querySelector('.menu-toggle');
                if (menuToggle) {
                    menuToggle.setAttribute('aria-expanded', 'false');
                }
            }
        }
    });
});

// ==========================================
// CLOSE MOBILE MENU ON OUTSIDE CLICK
// ==========================================
document.addEventListener('click', function(e) {
    const nav = document.getElementById('navLinks');
    const toggle = document.querySelector('.menu-toggle');
    
    if (!nav || !toggle) return;
    
    // If click is outside nav and toggle, close menu
    if (!nav.contains(e.target) && !toggle.contains(e.target)) {
        if (nav.classList.contains('active')) {
            nav.classList.remove('active');
            document.body.style.overflow = '';
            toggle.setAttribute('aria-expanded', 'false');
        }
    }
});

// ==========================================
// CLOSE MOBILE MENU ON ESC KEY
// ==========================================
document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') {
        const nav = document.getElementById('navLinks');
        const toggle = document.querySelector('.menu-toggle');
        
        if (nav && nav.classList.contains('active')) {
            nav.classList.remove('active');
            document.body.style.overflow = '';
            
            if (toggle) {
                toggle.setAttribute('aria-expanded', 'false');
                toggle.focus(); // Return focus to toggle button
            }
        }
    }
});

// ==========================================
// ADD SCROLLED CLASS TO NAVBAR
// ==========================================
let lastScrollTop = 0;
const navbar = document.querySelector('.navbar');

window.addEventListener('scroll', function() {
    if (navbar) {
        if (window.scrollY > 50) {
            navbar.classList.add('scrolled');
        } else {
            navbar.classList.remove('scrolled');
        }
    }
    lastScrollTop = window.scrollY;
}, { passive: true });

// ==========================================
// INTERSECTION OBSERVER FOR SCROLL ANIMATIONS
// ==========================================
const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -100px 0px'
};

const observer = new IntersectionObserver(function(entries) {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.style.opacity = '1';
            entry.target.style.transform = 'translateY(0)';
        }
    });
}, observerOptions);

// Observe elements on page load
document.addEventListener('DOMContentLoaded', function() {
    const animatedElements = document.querySelectorAll('.service-card, .pricing-card');
    
    animatedElements.forEach(el => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(30px)';
        el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        observer.observe(el);
    });
});

// ==========================================
// FORM VALIDATION (if contact form exists)
// ==========================================
const contactForm = document.getElementById('contactForm');

if (contactForm) {
    contactForm.addEventListener('submit', function(e) {
        e.preventDefault();
        
        // Get form fields
        const name = document.getElementById('name');
        const email = document.getElementById('email');
        const message = document.getElementById('message');
        
        // Basic validation
        let isValid = true;
        
        // Clear previous errors
        document.querySelectorAll('.error-message').forEach(el => el.remove());
        
        // Validate name
        if (!name.value.trim()) {
            showError(name, 'Name is required');
            isValid = false;
        }
        
        // Validate email
        if (!email.value.trim()) {
            showError(email, 'Email is required');
            isValid = false;
        } else if (!isValidEmail(email.value)) {
            showError(email, 'Please enter a valid email');
            isValid = false;
        }
        
        // Validate message
        if (!message.value.trim()) {
            showError(message, 'Message is required');
            isValid = false;
        }
        
        if (isValid) {
            // Form is valid, you can submit it
            // For now, just show success message
            showSuccessMessage();
            contactForm.reset();
        }
    });
}

function showError(input, message) {
    const errorDiv = document.createElement('div');
    errorDiv.className = 'error-message';
    errorDiv.style.color = '#E53E3E';
    errorDiv.style.fontSize = '0.875rem';
    errorDiv.style.marginTop = '0.25rem';
    errorDiv.textContent = message;
    
    input.style.borderColor = '#E53E3E';
    input.parentElement.appendChild(errorDiv);
    
    // Remove error on input
    input.addEventListener('input', function() {
        input.style.borderColor = '';
        const error = input.parentElement.querySelector('.error-message');
        if (error) error.remove();
    }, { once: true });
}

function isValidEmail(email) {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
}

function showSuccessMessage() {
    const successDiv = document.createElement('div');
    successDiv.className = 'success-message';
    successDiv.style.cssText = `
        position: fixed;
        top: 100px;
        right: 20px;
        background: #48BB78;
        color: white;
        padding: 1rem 1.5rem;
        border-radius: 10px;
        box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
        z-index: 9999;
        animation: slideInRight 0.5s ease;
    `;
    successDiv.textContent = 'Message sent successfully! We\'ll get back to you soon.';
    
    document.body.appendChild(successDiv);
    
    setTimeout(() => {
        successDiv.style.animation = 'slideOutRight 0.5s ease';
        setTimeout(() => successDiv.remove(), 500);
    }, 3000);
}





// ==========================================
// ADD LOADING STATE TO BUTTONS
// ==========================================
document.querySelectorAll('button[type="submit"]').forEach(button => {
    button.addEventListener('click', function() {
        const originalText = this.innerHTML;
        this.innerHTML = '<i data-feather="loader"></i> Sending...';
        this.disabled = true;
        
        // Re-initialize feather icons
        if (typeof feather !== 'undefined') {
            feather.replace();
        }
        
        // Reset after 3 seconds (adjust based on your needs)
        setTimeout(() => {
            this.innerHTML = originalText;
            this.disabled = false;
            if (typeof feather !== 'undefined') {
                feather.replace();
            }
        }, 3000);
    });
});

// ==========================================
// CONSOLE WELCOME MESSAGE (Optional)
// ==========================================
console.log('%c👋 Welcome to Online Psychologist!', 'color: #667eea; font-size: 20px; font-weight: bold;');
console.log('%cLooking for something? Feel free to reach out!', 'color: #4A5568; font-size: 14px;');
console.log('%cWhatsApp: +92 318 7036719', 'color: #25D366; font-size: 14px;');

// ==========================================
// PERFORMANCE: Defer non-critical scripts
// ==========================================
window.addEventListener('load', function() {
    // Any non-critical scripts can be loaded here
    console.log('✓ Page fully loaded');
});