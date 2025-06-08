<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<div class="sidebar bg-light border-end">
    <div class="list-group list-group-flush">
        <a class="list-group-item list-group-item-action" href="<%= request.getContextPath() %>/alquiler">Alquileres</a>
        
        <div class="list-group-item p-0">
            <a class="list-group-item list-group-item-action d-flex justify-content-between align-items-center" 
               data-bs-toggle="collapse" 
               href="#mantenimientoCollapse" 
               role="button" 
               aria-expanded="false" 
               aria-controls="mantenimientoCollapse">
                Mantenimiento
                <i class="bi bi-chevron-down"></i>
            </a>
            <div class="collapse" id="mantenimientoCollapse">
                <div class="list-group list-group-flush">
                    <a class="list-group-item list-group-item-action ps-4" href="<%= request.getContextPath() %>/cliente">Clientes</a>
                    <a class="list-group-item list-group-item-action ps-4" href="<%= request.getContextPath() %>/pelicula">Películas</a>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const mantenimientoCollapse = document.getElementById('mantenimientoCollapse');
    const collapseToggle = document.querySelector('[data-bs-toggle="collapse"]');
    
    const savedState = localStorage.getItem('mantenimientoCollapseState');
    
    if (savedState === 'show') {
        mantenimientoCollapse.classList.add('show');
        collapseToggle.setAttribute('aria-expanded', 'true');
    }
    
    mantenimientoCollapse.addEventListener('show.bs.collapse', function () {
        localStorage.setItem('mantenimientoCollapseState', 'show');
    });
    
    mantenimientoCollapse.addEventListener('hide.bs.collapse', function () {
        localStorage.setItem('mantenimientoCollapseState', 'hide');
    });

    const currentPath = window.location.pathname;
    const menuItems = document.querySelectorAll('.list-group-item-action');
    
    menuItems.forEach(item => {
        const href = item.getAttribute('href');
        if (href === currentPath) {
            item.classList.add('active');
            
            if (item.closest('#mantenimientoCollapse')) {
                mantenimientoCollapse.classList.add('show');
                collapseToggle.setAttribute('aria-expanded', 'true');
                localStorage.setItem('mantenimientoCollapseState', 'show');
            }
        }
    });
});
</script> 