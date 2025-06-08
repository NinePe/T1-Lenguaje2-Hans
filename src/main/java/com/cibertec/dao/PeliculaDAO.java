package com.cibertec.dao;

import com.cibertec.model.Pelicula;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import java.util.List;

public class PeliculaDAO {
    private EntityManagerFactory emf;
    private EntityManager em;
    
    public PeliculaDAO() {
        emf = Persistence.createEntityManagerFactory("default");
        em = emf.createEntityManager();
    }
    
    public void insertar(Pelicula pelicula) {
        try {
            em.getTransaction().begin();
            em.persist(pelicula);
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        }
    }
    
    public List<Pelicula> listar() {
        return em.createQuery("SELECT p FROM Pelicula p", Pelicula.class).getResultList();
    }
    
    public Pelicula buscar(Long id) {
        return em.find(Pelicula.class, id);
    }
    
    public void actualizar(Pelicula pelicula) {
        try {
            em.getTransaction().begin();
            em.merge(pelicula);
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        }
    }
    
    public void eliminar(Long id) {
        try {
            em.getTransaction().begin();
            Pelicula pelicula = em.find(Pelicula.class, id);
            if (pelicula != null) {
                em.remove(pelicula);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            em.getTransaction().rollback();
            throw e;
        }
    }
} 