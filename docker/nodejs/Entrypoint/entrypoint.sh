#!/bin/bash
echo "RUN CMD: npm run typeorm migration:run"
npm run typeorm migration:run

echo "START APP: npm start"
npm start