package com.cibertec.servlet;

import com.cibertec.dao.AlquilerDAO;
import com.cibertec.dao.ClienteDAO;
import com.cibertec.dao.PeliculaDAO;
import com.cibertec.model.Alquiler;
import com.cibertec.model.DetalleAlquiler;
import com.cibertec.model.Pelicula;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class AlquilerServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        AlquilerDAO alquilerDAO = new AlquilerDAO();
        ClienteDAO clienteDAO = new ClienteDAO();
        PeliculaDAO peliculaDAO = new PeliculaDAO();
        try {
            // Always list alquileres and provide clientes and peliculas for the modal
            List<Alquiler> alquileres = alquilerDAO.listar();
            List<com.cibertec.model.Cliente> clientes = clienteDAO.listar();
            List<Pelicula> peliculas = peliculaDAO.listar();
            req.setAttribute("alquileres", alquileres);
            req.setAttribute("clientes", clientes);
            req.setAttribute("peliculas", peliculas);
            req.setAttribute("contentPage", "Mantenimiento/alquileres.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error: " + e.getMessage());
            req.setAttribute("contentPage", "Mantenimiento/alquileres.jsp");
        }
        req.getRequestDispatcher("/WEB-INF/jsp/layout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        AlquilerDAO alquilerDAO = new AlquilerDAO();
        ClienteDAO clienteDAO = new ClienteDAO();
        PeliculaDAO peliculaDAO = new PeliculaDAO();
        String accion = req.getParameter("accion");
        try {
            if ("guardar".equals(accion)) {
                Alquiler alquiler = new Alquiler();
                alquiler.setFecha(java.time.LocalDateTime.now().format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
                alquiler.setCliente(clienteDAO.buscar(Long.parseLong(req.getParameter("idCliente"))));
                alquiler.setEstado(req.getParameter("estado"));
                // Parse detalles
                String[] idPeliculas = req.getParameterValues("idPelicula[]");
                String[] cantidades = req.getParameterValues("cantidad[]");
                List<DetalleAlquiler> detalles = new ArrayList<>();
                double total = 0.0;
                if (idPeliculas != null && cantidades != null) {
                    for (int i = 0; i < idPeliculas.length; i++) {
                        DetalleAlquiler detalle = new DetalleAlquiler();
                        Pelicula pelicula = peliculaDAO.buscar(Long.parseLong(idPeliculas[i]));
                        detalle.setPelicula(pelicula);
                        detalle.setCantidad(Integer.parseInt(cantidades[i]));
                        detalle.setAlquiler(alquiler);
                        detalles.add(detalle);
                        // If you have price, use it here. For now, just sum cantidad
                        total += detalle.getCantidad();
                    }
                }
                alquiler.setDetalles(detalles);
                alquiler.setTotal(total);
                alquilerDAO.insertar(alquiler);
            } else if ("actualizar".equals(accion)) {
                Long id = Long.parseLong(req.getParameter("id"));
                Alquiler alquiler = alquilerDAO.buscar(id);
                if (alquiler != null) {
                    alquiler.setCliente(clienteDAO.buscar(Long.parseLong(req.getParameter("idCliente"))));
                    alquiler.setEstado(req.getParameter("estado"));
                    // Parse detalles
                    String[] idPeliculas = req.getParameterValues("idPelicula[]");
                    String[] cantidades = req.getParameterValues("cantidad[]");
                    List<DetalleAlquiler> detalles = new ArrayList<>();
                    double total = 0.0;
                    if (idPeliculas != null && cantidades != null) {
                        for (int i = 0; i < idPeliculas.length; i++) {
                            DetalleAlquiler detalle = new DetalleAlquiler();
                            Pelicula pelicula = peliculaDAO.buscar(Long.parseLong(idPeliculas[i]));
                            detalle.setPelicula(pelicula);
                            detalle.setCantidad(Integer.parseInt(cantidades[i]));
                            detalle.setAlquiler(alquiler);
                            detalles.add(detalle);
                            total += detalle.getCantidad();
                        }
                    }
                    // Fix: clear and add to the existing detalles list instead of replacing it
                    if (alquiler.getDetalles() != null) {
                        alquiler.getDetalles().clear();
                        alquiler.getDetalles().addAll(detalles);
                    } else {
                        alquiler.setDetalles(detalles);
                    }
                    alquiler.setTotal(total);
                    alquilerDAO.actualizar(alquiler);
                }
            } else if ("eliminar".equals(accion)) {
                Long id = Long.parseLong(req.getParameter("id"));
                alquilerDAO.eliminar(id);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        resp.sendRedirect(req.getContextPath() + "/alquiler");
    }
} 