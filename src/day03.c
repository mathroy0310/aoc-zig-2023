#include <ctype.h>
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>

bool IS_PART1 = false;

#define WIDTH 142
#define HEIGHT 142
#define BUFFER_SIZE 145

char tab[HEIGHT][WIDTH] = {0};

int getnumber(int x, int y)
{
	int result;
	while (isdigit(tab[x][y]))
		y--;
	result = strtol(tab[x] + (++y), NULL, 10);
	while (isdigit(tab[x][y]))
		tab[x][y++] = '.';
	return (result);
}

int getparts(int x, int y)
{
	int sum = 0;
	for (size_t j = x - 1; j < x + 2; j++)
		for (size_t k = y - 1; k < y + 2; k++)
			if (isdigit(tab[j][k]))
				sum += getnumber(j, k);
	return (sum);
}

int getgears(int x, int y)
{
	int nums = 0;
	int sum = 0;
	for (size_t j = x - 1; j < x + 2; j++)
		for (size_t k = y - 1; k < y + 2; k++)
			if (isdigit(tab[j][k]))
			{
				if (nums == 0)
					sum += getnumber(j, k);
				else if (nums == 1)
					sum *= getnumber(j, k);
				else if (nums == 2)
					return (0);
				nums++;
			}
	if (nums == 1)
		return (0);
	return (sum);
}

int main(void)
{
	char *filename = "input_day03.txt";
	char buffer[BUFFER_SIZE];
	int x = 0;
	FILE *f;
	f = fopen(filename, "r");
	long result = 0;
	while (fgets(buffer, BUFFER_SIZE, f) != NULL)
	{
		buffer[BUFFER_SIZE - 5] = '\0';
		strcpy(tab[++x] + 1, buffer);
	}
	if (IS_PART1)
	{
		for (x = 1; x < HEIGHT; x++)
			for (size_t y = 1; y < WIDTH; y++)
				if (tab[x][y] != '\0' && tab[x][y] != '.' && !isdigit(tab[x][y]))
					result += getparts(x, y);
		printf("[Part 1] result total :  %ld\n", result);
	}	
	else
	{
		for (x = 1; x < HEIGHT; x++)
			for (size_t y = 1; y < WIDTH; y++)
				if (tab[x][y] == '*')
					result += getgears(x, y);
		printf("[Part 2] result total :  %ld\n", result);
	}
	return (EXIT_SUCCESS);
}