const request = require('supertest');
const app = require('../src/app');

describe('API endpoints', () => {
  test('GET /health returns 200 and ok status', async () => {
    const response = await request(app).get('/health');
    expect(response.status).toBe(200);
    expect(response.body).toEqual({ status: 'ok' });
  });

  test('GET /version returns version string', async () => {
    const response = await request(app).get('/version');
    expect(response.status).toBe(200);
    expect(response.body).toHaveProperty('version');
    expect(typeof response.body.version).toBe('string');
  });

  test('POST /echo returns the request body', async () => {
    const payload = { message: 'hello' };
    const response = await request(app).post('/echo').send(payload);
    expect(response.status).toBe(200);
    expect(response.body).toEqual({ echo: payload });
  });

  test('POST /echo without body returns empty echo', async () => {
    const response = await request(app).post('/echo');
    expect(response.status).toBe(200);
    expect(response.body).toEqual({ echo: {} });
  });
});
