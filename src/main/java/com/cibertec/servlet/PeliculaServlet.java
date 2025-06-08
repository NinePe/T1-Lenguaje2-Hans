package com.cibertec.servlet;

import com.cibertec.dao.PeliculaDAO;
import com.cibertec.model.Pelicula;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class PeliculaServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        PeliculaDAO peliculaDAO = new PeliculaDAO();
        try {
            List<Pelicula> peliculas = peliculaDAO.listar();
            req.setAttribute("peliculas", peliculas);
            req.setAttribute("contentPage", "Mantenimiento/peliculas.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Error: " + e.getMessage());
            req.setAttribute("contentPage", "Mantenimiento/peliculas.jsp");
        }
        req.getRequestDispatcher("/WEB-INF/jsp/layout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        PeliculaDAO peliculaDAO = new PeliculaDAO();
        String accion = req.getParameter("accion");
        try {
            if ("guardar".equals(accion)) {
                Pelicula pelicula = new Pelicula();
                pelicula.setTitulo(req.getParameter("titulo"));
                pelicula.setGenero(req.getParameter("genero"));
                pelicula.setStock(Integer.parseInt(req.getParameter("stock")));
                peliculaDAO.insertar(pelicula);
            } else if ("actualizar".equals(accion)) {
                Long id = Long.parseLong(req.getParameter("id"));
                Pelicula pelicula = peliculaDAO.buscar(id);
                if (pelicula != null) {
                    pelicula.setTitulo(req.getParameter("titulo"));
                    pelicula.setGenero(req.getParameter("genero"));
                    pelicula.setStock(Integer.parseInt(req.getParameter("stock")));
                    peliculaDAO.actualizar(pelicula);
                }
            } else if ("eliminar".equals(accion)) {
                Long id = Long.parseLong(req.getParameter("id"));
                peliculaDAO.eliminar(id);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        resp.sendRedirect(req.getContextPath() + "/pelicula");
    }
} 