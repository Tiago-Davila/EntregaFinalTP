-- FUNCIONES ------------------------------------------------------------
-- 1
delimiter //
create function comprarProducto(idP int, idMP int, idEnvio int, cant int, idUsuarioComprador int, idVD int) returns text deterministic
begin
	if idP in(select idPublicacion from Publicacion where idPublicacion = idP and estado = 'No disponible') then 
		return "La publicacion no esta activa";
	else if idP in(select idPublicacion from Publicacion where idPublicacion = idP and Tipo = 'Subasta') then
		return "Es una subasta";
	else if idP in(select idPublicacion from Publicacion join VentaDirecta on Publicacion_idPublicacion = idPublicacion 
    where idPublicacion = idP and idMP = MedioPago_idMedioPago and idEnvio = Envio_idEnvio and Tipo = 'Venta directa' and idVentaDirecta = idVD) then
		insert into Compra value(null, curdate(), cant, idVD, null, null, idUsuarioComprador);
        return "Compra exitosa";
	else
		return "Error en la compra";
	end if;
    end if;
    end if;
end //
delimiter ;
drop function comprarProducto;
select comprarProducto(1, 1, 1, 10, 2, 1);
-- nota: tienen que estar asociados correctamente los ids de envio, metodo de pago y el de venta directa 
-- por los parametros, si no esta mal
-- 2
delimiter $$
create function cerrarPublicacion(idUsuario int, idP int) returns text deterministic
begin
	if exists(select idPublicacion from Publicacion join VentaDirecta 
    on idPublicacion = Publicacion_idPublicacion join Compra on idVentaDirecta = VentaDirecta_idVentaDirecta 
    where usuarioVendedor = idUsuario and idPublicacion = idP and calificacionVendedor is not null and
    calificacionComprador is not null) then
		update Publicacion set estado = "No disponible" where idPublicacion = idP;
		return 'Se ha cambiado el estado de la publicación';
	else 
		return 'Error, no se cambio el estado de la publicación';
    end if;
end $$
delimiter ;
drop function cerrarPublicacion;
select cerrarPublicacion(1, 1);
-- 3
-- producto para probar
insert into Producto value(166, 1, "dasda", "bondi gato");
delimiter &&
create function eliminarProducto(idProd int) returns text deterministic
begin
	if idProd not in(select Producto_idProducto from Publicacion where Producto_idProducto = idProd) then
		delete from Producto where idProducto = idProd;
        return "Producto eliminado";
	else
		return "El producto tiene publicaciones asociadas, no se puede eliminar";
	end if;
end &&
delimiter ;
drop function eliminarProducto;
select eliminarProducto(166);
-- 4
delimiter <<
create function pausarPublicacion(idPubli int) returns text deterministic
begin
	if exists(select idPublicacion from Publicacion where idPublicacion = idPubli and estado != "Pausada") then
		update Publicacion set estado = "Pausada" where idPublicacion = idPubli;
		return "Publicacion pausada exitosamente";
	else if exists(select idPublicacion from Publicacion where idPublicacion = idPubli and estado = "Pausada") then
		return "La publicacion ya esta pausada";
	else
		return "No existe la publicacion";
	end if;
	end if;
end <<
delimiter ;
select pausarPublicacion(1);
-- 5
delimiter //
create function pujarProducto(idPubli int, puja int) returns text deterministic
begin
	declare pO int default 0;
    set pO = (select precioOfertado from Oferta join Subasta on 
    idSubasta = Subasta_idSubasta where Publicacion_idPublicacion = idPubli);
	if idPubli in(select Publicacion_idPublicacion from Subasta join Oferta on Subasta_idSubasta = idSubasta 
    where Publicacion_idPublicacion = idPubli) and puja > pO then
		update Oferta join Subasta on Subasta_idSubasta = idSubasta set precioOfertado = puja 
        where Publicacion_idPublicacion = idPubli;
        return "Precio ofertado exitosamente";
	else if idPubli in(select Publicacion_idPublicacion from Subasta join Oferta on Subasta_idSubasta = idSubasta
    where Publicacion_idPublicacion = idPubli) and puja < pO then 
		return "El precio para la puja es inferior al mayor precio ofertado";
	else
		return "No existe la publicación";
	end if;
	end if;
end //
delimiter ;
drop function pujarProducto;
select pujarProducto(3, 10000);
-- 6
insert into Categoria value(166, "ashe");
delimiter &&
create function eliminarCategoria(idCat int) returns text deterministic
begin
	if not exists(select idCategoria from Categoria where idCategoria = idCat) then
		return "La categoría no existe";
	else if idCat not in(select idCategoria from Categoria join Producto on 
    Categoria_idCategoria = idCategoria join Publicacion on 
    Producto_idProducto = idProducto where Categoria_idCategoria = idCat ) then
		delete from Categoria where idCategoria = idCat;
		return "Categoría eliminada exitosamente";
	else 
		return "La categoría tiene publicaciones activas";
	end if;
    end if;
end &&
delimiter ;
drop function eliminarCategoria;
select eliminarCategoria(1);
-- 7
delimiter %%
create function puntuarComprador(idPubli int, vendedor int, calCompra int, comprador int) returns text deterministic
begin
	if exists(select Publicacion_idPublicacion from VentaDirecta join Publicacion 
    on idPublicacion = Publicacion_idPublicacion where usuarioVendedor = vendedor and idPublicacion = idPubli) then
		update Compra set calificacionComprador = calCompra where usuarioComprador = comprador;
		return "Usuario calificado con éxito";
    else 
		return "Error, no existe la publicacion o el usuario vendedor ingresados";
	end if;
end %%
delimiter ;
drop function puntuarComprador;
select puntuarComprador(1, 1, 5, 2);
-- nota: hay que chequear las relaciones como en el 1 (los id) para probarlo
-- 8
delimiter $$
create function responderPregunta(idVendedor int, respuesta VARCHAR(45)) returns text deterministic
begin
	if idVendedor in(select usuarioVendedor from Publicacion where usuarioVendedor = idVendedor) then
		insert into Respuesta value(null, respuesta);
		return "Pregunta respondida exitosamente";
	else 
		return "El DNI del vendedor no coincide con el del dueño de la publicación";
	end if;
end $$
delimiter ;
drop function responderPregunta;
select responderPregunta(1, "Hola, si");
-- Procedures-------------------------------------------------------------------------------------------------------------------
-- 1
delimiter //
create procedure buscarPublicacion(in nombreProducto text)
begin 
select idPublicacion, Producto.nombre, precio, Categoria.nombre as nombreCat from Publicacion 
join Producto on idProducto=Producto_idProducto 
join Categoria on idCategoria=Categoria_idCategoria where Producto.nombre=nombreProducto;
end//
delimiter ;
drop procedure buscarPublicacion;
call buscarPublicacion("Bici B4");
-- 2
delimiter //
create procedure crearPublicacion(in PublicacionID int, in tipo text, in fecha date, in estadoP text,
in nivelP text, in precio int, in productoID int, in UsuarioID int,  in SubastaID int, in fechaIN date, in fechaF date, in precioF int, 
in idVentaD int, in dir varchar(45), in idMedio int , in envioID int)
begin
insert into Publicacion values(PublicacionID,  tipo, fecha, estadoP, nivel, precio,  productoID, UsuarioID);
if tipo = "Venta Directa" then insert into VentaDirecta values(idVentaD, dir, idMedio, envioID, PublicacionID);
else if tipo = "Subasta" then insert into Subasta values(SubastaID, fechaIN, fechaF, precioF, PublicacionID);
end if;
end if;
end//
delimiter ;
drop procedure crearPublicacion;
call crearPublicacion(8, 'Venta directa', '2025-06-01', 'Disponible', 'Bronce', 550, 1, 2, null, null, null, null, 6, 'Av. Siempre Viva 123', 1, 1);

            
-- 3
delimiter //
create procedure verPreguntas(in PublicacionID int)
begin 
select idPreguntas,  pregunta from Pregunta 
where Publicacion_idPublicacion=PublicacionID;
end //
delimiter ;
drop procedure verPreguntas;
call verPreguntas(1);
-- 4
delimiter //
create procedure actualizarReputacionUsuarios()
begin
  declare hayFilas int default false;
  declare Idusuario int default 0;
  declare promcomprador float default 0.0;
  declare promvendedor float default 0.0;
  declare promfinal float default 0.0;
  declare cursorAct cursor for select idusuario from Usuario;
  declare continue handler for not found set hayFilas = true;
  open cursorAct;
  loopAct: loop
    fetch cursorAct into Idusuario;
    if hayFilas then
      leave loopAct;
    end if;
    select avg(calificacionComprador)into promcomprador from Compra where usuarioComprador = Idusuario
    and calificacionComprador is not null;
    
    select avg(calificacionVendedor) into promvendedor from Compra 
    join VentaDirecta on ventadirecta_idventadirecta = idventadirecta
    join Publicacion on publicacion_idpublicacion = idpublicacion
    where Publicacion.usuarioVendedor = Idusuario and calificacionVendedor is not null;
    
    if promcomprador is null and promvendedor is null then set promfinal = 0;
    elseif promcomprador is null then set promfinal = promvendedor;
    elseif promvendedor is null then set promfinal = promcomprador;
    else set promfinal = (promcomprador + promvendedor) DIV 2;
    end if;
    update Usuario set reputacion = promfinal where idUsuario = Idusuario;
  end loop;
  close cursorAct;
end //

delimiter ;
drop procedure actualizarReputacionUsuarios;
call actualizarReputacionUsuarios();
-- Vistas-------------------------------------------------------------------------------------------------------------------
-- 1 
CREATE VIEW pregun AS SELECT idPregunta, pregunta, Publicacion_idPublicacion,
Producto.nombre, Usuario.nombre as nombreU
FROM Pregunta
JOIN Publicacion ON Publicacion_idPublicacion = Publicacion.idPublicacion 
JOIN Usuario ON usuarioPregunta = Usuario.idUsuario 
JOIN Producto ON Producto_idProducto = Producto.idProducto 
WHERE Respuesta_idRespuesta IS NULL 
AND estado = "Disponible";
 
SELECT * FROM pregun;
 
-- 2 
CREATE VIEW Top10cat AS
SELECT Categoria.nombre, COUNT(*) AS d FROM Categoria
JOIN Producto ON Categoria_idCategoria = idCategoria
JOIN Publicacion ON Producto_idProducto = idProducto
WHERE fechaInicio > DATE_SUB(CURRENT_DATE(), INTERVAL 7 DAY)
GROUP BY Categoria.nombre
ORDER BY d DESC
LIMIT 10;
 
SELECT * FROM Top10cat ;
 
-- 3 
CREATE VIEW TopPubli AS SELECT idPublicacion FROM Publicacion
JOIN Pregunta ON Publicacion_idPublicacion = idPublicacion 
WHERE fechaInicio = CURRENT_DATE()
GROUP BY idPublicacion 
ORDER BY count(*) DESC ;
 
SELECT * FROM TopPubli ;
 
-- 4 
CREATE VIEW Vendedor AS SELECT Usuario.nombre , Categoria.nombre as nombreC, idCategoria FROM Usuario 
JOIN Publicacion ON usuarioVendedor = idUsuario 
JOIN Producto ON idProducto = Producto_idProducto
JOIN Categoria ON Categoria_idCategoria = idCategoria 
WHERE reputacion IN (SELECT max(reputacion) FROM Usuario) 
GROUP BY idCategoria, idUsuario;
SELECT * FROM Vendedor ;
-- Eventos-------------------------------------------------------------------------------------------------------------------
-- ej 1--
delimiter //
create event eliminPublicaPausadas on SCHEDULE every 1 week starts now() do
begin
	delete from Publicacion where estado != "Disponible" and fechaInicio >= DATE_SUB(CURDATE(), INTERVAL 90 DAY);
end //
 
delimiter ;
 
-- ej 2--
 
delimiter //
create event Observadas on SCHEDULE every 1 day starts now() do
begin
	update Publicacion join VentaDirecta on Publicacion_idPublicacion = idPublicacion set estado = "Observadas" 
    where estado = "Disponible" and MedioPago_idMedioPago is null;
end //
 
 
-- Triggers--------------------------------------------------------------------
-- ej 1--
delimiter //
create trigger borrarPreguntas before delete on Publicacion for each row
begin
	delete from Pregunta where Publicacion_idPublicacion = old.idPublicacion;
end//
delimiter ;
-- ejercicio 2-
-- falta terminar-
delimiter //
create trigger verificarCalificacion after update on Compra for each row 
begin
	declare idV int;
    declare idC int;
	if ( new.calificacionVendedor is not null and new.calificacionComprador is not null) then
		set idV = select usuarioVendedor from Pubicacion 
        join VentaDirecta on Publicacion_idPublicacion = idPublicacion where new.VentaDirecta_idVentaDirecta = idVentaDirecta	
        set idC = select usuarioComprador from Compra ;
	-- Asumimos que tenemos estas 2 funciones--
	call actualizarCalificacionPorUsuario(idC);
	call actualizarCalificacionPorUsuario(idV);
	-- --- --- --- --- --- -- -- -- - -- -- -- -- - -- --- --- - --
	end if;
    end if;
end ;
delimiter ;
-- ejercicio 3 trigger-
delimiter // 
create trigger cambiarCategoria after insert on Compra for each row
begin
	declare VentasH int;
	declare idV int default 0;
	set idV = ( select usuarioVendedor from Publicacion 
    join VentaDirecta on VentaDirecta.Publicacion_idPublicacion = Publicacion.idPublicacion where 
    new.VentaDirecta_idVentaDirecta = idVentaDirecta );
	select count(*) into VentasH from Publicacion join VentaDirecta on VentaDirecta.Publicacion_idPublicacion = Publicacion.idPublicacion
    join Compra on idVentaDirecta = Compra.VentaDirecta_idVentaDirecta where 
    usuarioVendedor = idV;
    if ( VentasH >= 1 and VentasH <= 5) then
		update Usuario set nivel = "Normal" where idUsuario = idV;
	else if ( VentasH >= 6 and VentasH <= 10 ) then
		update Usuario set nivel = "Platinum" where idUsuario = idV;
	else if ( VentasH >= 11 ) then
		update Usuario set nivel = "Gold" where idUsuario = idV;
    end if;
    end if;
    end if;
end//
delimiter ;
-- Transaccion 1---------------------------------------------------------------------------
delimiter $$
create procedure crearPublicacion (tipo text,fechaI date, Estado text, nvl text, Precio int ,idPR int, idUS int  )
begin
	insert into Publicacion values(tipo, fechaI, Estado, nvl, Precio, idPR, idUS);
    end $$
delimiter ;
-- ejercicio 2 Transacciones-
delimiter //
create procedure actualizarReputacionUsuarios()
begin
  declare hayFilas int default false;
  declare Idusuario int default 0;
  declare promcomprador float default 0.0;
  declare promvendedor float default 0.0;
  declare promfinal float default 0.0;
  declare cursorAct cursor for select idusuario from Usuario;
  declare continue handler for not found set hayFilas = true;
  open cursorAct;
  loopAct: loop
    fetch cursorAct into Idusuario;
    if hayFilas then
      leave loopAct;
    end if;
    start transaction;
    select avg(calificacionComprador)into promcomprador from Compra where usuarioComprador = Idusuario
    and calificacionComprador is not null;
    select avg(calificacionVendedor) into promvendedor from Compra 
    join VentaDirecta on ventadirecta_idventadirecta = idventadirecta
    join Publicacion on publicacion_idpublicacion = idpublicacion
    where Publicacion.usuarioVendedor = Idusuario and calificacionVendedor is not null;
    if (promvendedor > 0 and promvendedor < 100) then
		commit;
	else
		rollback;
	end if;
    if promcomprador is null and promvendedor is null then set promfinal = 0;
    elseif promcomprador is null then set promfinal = promvendedor;
    elseif promvendedor is null then set promfinal = promcomprador;
    else set promfinal = (promcomprador + promvendedor) DIV 2;
    end if;
    update Usuario set reputacion = promfinal where idUsuario = Idusuario;
    if (promcomprador > 0 and promcomprador < 100) then
		commit;
	else
		rollback;
	end if;
  end loop;
  close cursorAct;
end //
delimiter ;
call crearVentaDirecta();

-- indices -------------------------------------------------------------------------------------------------------------------
create index Indice_producto_nombre on Producto(nombre(255));
explain analyze select * from Publicacion  join Producto  on producto_idproducto = idproducto where nombre = 'bicicleta';
create unique index Indice_usuario_email on Usuario(email);
create index publicacion_indice on Publicacion(estado);
explain analyze select * from Publicacion where estado = 'Disponible' and nivel = 'Plata';
