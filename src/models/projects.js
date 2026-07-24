import db from './db.js'

const getAllProjects = async () => {
    const query = `
        SELECT project.project_id, project.title, project.description, project.location, project.date,
               organization.name AS organization_name
        FROM public.project
        JOIN public.organization ON project.organization_id = organization.organization_id;
    `;
    const result = await db.query(query);
    return result.rows;
}

const getProjectsByOrganizationId = async (organizationId) => {
    const query = `
        SELECT project_id, organization_id, title, description, location, date
        FROM public.project
        WHERE organization_id = $1
        ORDER BY date;
    `;
    const result = await db.query(query, [organizationId]);
    return result.rows;
}

const getUpcomingProjects = async (number_of_projects) => {
    const query = `
        SELECT project.project_id, project.title, project.description, project.location, project.date,
               organization.organization_id, organization.name AS organization_name
        FROM public.project
        JOIN public.organization ON project.organization_id = organization.organization_id
        WHERE project.date >= CURRENT_DATE
        ORDER BY project.date ASC
        LIMIT $1;
    `;
    const result = await db.query(query, [number_of_projects]);
    return result.rows;
}

const getProjectDetails = async (id) => {
    const query = `
        SELECT project.project_id, project.title, project.description, project.location, project.date,
               organization.organization_id, organization.name AS organization_name
        FROM public.project
        JOIN public.organization ON project.organization_id = organization.organization_id
        WHERE project.project_id = $1;
    `;
    const result = await db.query(query, [id]);
    return result.rows.length > 0 ? result.rows[0] : null;
}

const getProjectsByCategoryId = async (categoryId) => {
    const query = `
        SELECT project.project_id, project.title, project.description, project.location, project.date,
               organization.name AS organization_name
        FROM public.project
        JOIN public.organization ON project.organization_id = organization.organization_id
        JOIN public.project_category ON project.project_id = project_category.project_id
        WHERE project_category.category_id = $1
        ORDER BY project.date;
    `;
    const result = await db.query(query, [categoryId]);
    return result.rows;
}

const createProject = async (title, description, location, date, organizationId) => {
    const query = `
        INSERT INTO project (title, description, location, date, organization_id)
        VALUES ($1, $2, $3, $4, $5)
        RETURNING project_id
    `;
    const result = await db.query(query, [title, description, location, date, organizationId]);
    if (result.rows.length === 0) throw new Error('Failed to create project');
    return result.rows[0].project_id;
};

const updateProject = async (id, title, description, location, date, organizationId) => {
    const query = `
        UPDATE project
        SET title = $2, description = $3, location = $4, date = $5, organization_id = $6
        WHERE project_id = $1
        RETURNING project_id
    `;
    const result = await db.query(query, [id, title, description, location, date, organizationId]);
    if (result.rows.length === 0) throw new Error('Failed to update project');
    return result.rows[0].project_id;
};

export {
    getAllProjects,
    getProjectsByOrganizationId,
    getUpcomingProjects,
    getProjectDetails,
    getProjectsByCategoryId,
    createProject,
    updateProject
}