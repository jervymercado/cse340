import db from './db.js'

const getAllCategories = async () => {
    const query = `
        SELECT category_id, name
        FROM public.category;
    `;
    const result = await db.query(query);
    return result.rows;
}

const getCategoryDetails = async (categoryId) => {
    const query = `
        SELECT category_id, name
        FROM public.category
        WHERE category_id = $1;
    `;
    const result = await db.query(query, [categoryId]);
    return result.rows.length > 0 ? result.rows[0] : null;
}

const getCategoriesByProjectId = async (projectId) => {
    const query = `
        SELECT category.category_id, category.name
        FROM public.category
        JOIN public.project_category ON category.category_id = project_category.category_id
        WHERE project_category.project_id = $1
        ORDER BY category.name;
    `;
    const result = await db.query(query, [projectId]);
    return result.rows;
}

const createCategory = async (name) => {
    const query = `
        INSERT INTO category (name)
        VALUES ($1)
        RETURNING category_id
    `;
    const result = await db.query(query, [name]);
    if (result.rows.length === 0) throw new Error('Failed to create category');
    return result.rows[0].category_id;
};

const updateCategory = async (id, name) => {
    const query = `
        UPDATE category
        SET name = $2
        WHERE category_id = $1
        RETURNING category_id
    `;
    const result = await db.query(query, [id, name]);
    if (result.rows.length === 0) throw new Error('Failed to update category');
    return result.rows[0].category_id;
};

const assignCategoryToProject = async (projectId, categoryId) => {
    const query = `
        INSERT INTO project_category (project_id, category_id)
        VALUES ($1, $2)
    `;
    await db.query(query, [projectId, categoryId]);
};

const updateCategoryAssignments = async (projectId, categoryIds) => {
    const deleteQuery = `DELETE FROM project_category WHERE project_id = $1`;
    await db.query(deleteQuery, [projectId]);

    for (const categoryId of categoryIds) {
        await assignCategoryToProject(projectId, categoryId);
    }
};

export {
    getAllCategories,
    getCategoryDetails,
    getCategoriesByProjectId,
    createCategory,
    updateCategory,
    updateCategoryAssignments
}